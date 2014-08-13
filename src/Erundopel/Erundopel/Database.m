//
//  Database.m
//  Erundopel
//
//  Created by Admin on 04/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "Database.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "Meaning.h"
#import "Word.h"
#import "Article.h"
#import "Card.h"

@interface Database ()


@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation Database

// CR: do NOT indent text inside a line.
// CR: use 'static NSString *const blabla' for string constants.
static NSString *const tableNameLanguages = @"languages";
static NSString *const tableNameMeanings = @"meanings";
static NSString *const tableNameWords = @"words";
static NSString *const tableNameCards = @"cards";
static NSString *const tableNameMeaningPopularity = @"meaning_popularity";

NSString *queryDropTable = @"DROP TABLE ?";

+ (instancetype) sharedInstance
{
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype) initUniqueInstance
{
    self = [super init];
    
    // initialize queue for all queries
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *DBDirectory = [documentsDirectory stringByAppendingPathComponent:@"Database"];
    
    NSError *error;

    if (![[NSFileManager defaultManager] createDirectoryAtPath:DBDirectory
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create database directory error: %@", error);
    }

    NSString *writableDBPath = [DBDirectory stringByAppendingPathComponent:@"erundopel.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:writableDBPath];
    
    [self createScheme];
    
    return self;
}

// only to be called from constructor
- (void)createScheme {
    [self.queue inDatabase:^(FMDatabase *db) {
        // Languages (independent)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS languages ("
            "id INTEGER PRIMARY KEY,"
            "id_object TEXT,"
            "name TEXT"
            ")"
        ];
        
        // Meanings (depends on Languages)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS meanings ("
            "id INTEGER PRIMARY KEY,"
            "id_object TEXT,"
            "meaning TEXT,"
            "id_language TEXT,"
            "FOREIGN KEY(id_language) REFERENCES languages(id_object)"
            ")"
        ];
        
        // Words (depends on Languages and Meanings)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS words ("
            "id INTEGER PRIMARY KEY,"
            "id_object TEXT,"
            "word TEXT,"
            "id_language TEXT,"
            "id_meaning TEXT,"
            "FOREIGN KEY(id_language) REFERENCES languages(id_object),"
            "FOREIGN KEY(id_meaning) REFERENCES meanings(id_object)"
            ")"
        ];
        
        // Cards (depends on Words)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS cards ("
            "id INTEGER PRIMARY KEY,"
            "id_object TEXT,"
            "id_word INTEGER,"
            "id_meaning_false_1 INTEGER,"
            "id_meaning_false_2 INTEGER,"
            "FOREIGN KEY(id_word) REFERENCES words(id),"
            "FOREIGN KEY(id_meaning_false_1) REFERENCES meanings(id),"
            "FOREIGN KEY(id_meaning_false_2) REFERENCES meanings(id)"
            ")"
        ];
        
        // Meaning popularity (depends on Words and Meanings)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS meaning_popularity ("
            "id_word INTEGER,"
            "id_meaning INTEGER,"
            "count INTEGER,"
            "FOREIGN KEY(id_word) REFERENCES words(id),"
            "FOREIGN KEY(id_meaning) REFERENCES meanings(id)"
            ")"
        ];
    }];
}

- (void)dropAllTables {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DROP TABLE languages"];
        [db executeUpdate:@"DROP TABLE meanings"];
        [db executeUpdate:@"DROP TABLE words"];
        [db executeUpdate:@"DROP TABLE cards"];
        [db executeUpdate:@"DROP TABLE meaning_popularity"];
    }];
}

- (void)wipeAllTables {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM languages"];
        [db executeUpdate:@"DELETE FROM meanings"];
        [db executeUpdate:@"DELETE FROM words"];
        [db executeUpdate:@"DELETE FROM cards"];
        [db executeUpdate:@"DELETE FROM meaning_popularity"];
    }];
}


- (NSArray *)getAllFixedCards
{
    NSMutableArray *__block mutableArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *__block cardsArray = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet * cardResult = [db executeQuery:
            @"SELECT id_word, id_meaning_false_1, id_meaning_false_2 "
            "FROM cards"
        ];
        
        while ([cardResult next]) {
            [cardsArray addObject:[cardResult resultDictionary]];
        }
    }];
    
    for (NSDictionary *cardDict in cardsArray) {
        Article *article = [self getArticleForWordById:cardDict[@"id_word"]];
        Meaning *meaning_false_1 = [self getMeaningByObjectId:cardDict[@"id_meaning_false_1"]];
        Meaning *meaning_false_2 = [self getMeaningByObjectId:cardDict[@"id_meaning_false_2"]];
        NSArray *meanings = @[
            meaning_false_1,
            meaning_false_2
        ];
        
        Card *card = [[Card alloc]
            initWithArticle:article
            falseMeaning:meanings[0]
            falseMeaning:meanings[1]
        ];
        
        [mutableArray addObject:card];
    }
    
    return mutableArray;
}

- (Article *)getArticleForWordById:(NSString *)wordId
{
    Word *__block word = nil;
    Meaning *__block meaning = nil;
    
    NSString *__block meaningId = 0;
    
    // create Word and get meaning id
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *wordResult = [db executeQuery:
            @"SELECT word, id_meaning "
            "FROM words "
            "WHERE words.id_object = ?",
            wordId
        ];
        
        if ([wordResult next]) {
            NSString *wordString = [wordResult stringForColumn:@"word"];
            word = [[Word alloc] initWithText:wordString];
            
            meaningId = [wordResult stringForColumn:@"id_meaning"];
            [wordResult close];
        }
    }];
    
    meaning = [self getMeaningByObjectId:meaningId];
    
    return [[Article alloc] initWithWord:word meaning:meaning];
}

- (Meaning *)getMeaningByObjectId:(NSString *)meaningId
{
    Meaning *__block meaning = nil;
    
    // create Word and get meaning id
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *meaningResult = [db executeQuery:
            @"SELECT meaning "
            "FROM meanings "
            "WHERE id_object = ?",
            meaningId
        ];
        
        if ([meaningResult next]) {
            NSString *meaningString = [meaningResult stringForColumn:@"meaning"];
            meaning = [[Meaning alloc] initWithText:meaningString];
            
            [meaningResult close];
        }
    }];
    
    return meaning;
}

- (NSArray *)getAllMeanings {
    NSMutableArray *__block mutableArray = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *s = [db executeQuery:@"SELECT * FROM meanings;"];
//        while ([s next]) {
//            NSString *meaningString = [s stringForColumn:@"meaning"];
//            Meaning *meaning = [[Meaning alloc]initWithText:meaningString];
//            [mutableArray addObject:meaning];
//        }
    }];
    return mutableArray;
}

- (NSArray *)getRandomArticles:(unsigned int)amount {
    NSMutableArray *__block articlesArray = [[NSMutableArray alloc] init];
    
    NSMutableSet *__block wordObjectIds = [[NSMutableSet alloc] init];

    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *maxIdResult = [db executeQuery:
            @"SELECT id "
            "FROM words "
            "ORDER BY id DESC "
            "LIMIT 1"
        ];
        
        unsigned int maxId = 0;
        
        if ([maxIdResult next]) {
            maxId = [maxIdResult intForColumn:@"id"];
        }
        [maxIdResult close];
        
        if (maxId > 0) {
            while ([wordObjectIds count] < amount) {
                 FMResultSet *wordResult = [db executeQuery:
                    @"SELECT id_object "
                    "FROM words "
                    "WHERE id = ? "
                    "LIMIT 1",
                    [NSNumber numberWithInt:(arc4random() % maxId)]
                ];
                
                if ([wordResult next]) {
                    NSString *wordObjectId = [wordResult stringForColumn:@"id_object"];
                    [wordObjectIds addObject:wordObjectId];
                }
                [wordResult close];
            }
        }
    }];
    
    for (NSString *wordObjectId in wordObjectIds) {
        [articlesArray addObject:[self getArticleForWordById:wordObjectId]];
    }
    
    return articlesArray;
}

- (NSSet *)getRandomMeanings:(unsigned int)amount {
    NSMutableSet *__block meaningsSet = [[NSMutableSet alloc] init];

    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *maxIdResult = [db executeQuery:
            @"SELECT id "
            "FROM meanings "
            "ORDER BY id DESC "
            "LIMIT 1"
        ];
        
        unsigned int maxId = 0;
        
        if ([maxIdResult next]) {
            maxId = [maxIdResult intForColumn:@"id"];
        }
        [maxIdResult close];
        
        if (maxId > 0) {
            while ([meaningsSet count] < amount) {
                FMResultSet *meaningResult = [db executeQuery:
                    @"SELECT meaning "
                    "FROM meanings "
                    "WHERE id = ? "
                    "LIMIT 1",
                    [NSNumber numberWithInt:(arc4random() % maxId)]
                ];
                
                if ([meaningResult next]) {
                    NSString *meaning = [meaningResult stringForColumn:@"meaning"];
                    [meaningsSet addObject:[[Meaning alloc] initWithText:meaning]];
                }
                [meaningResult close];
            }
        }
    }];
    
    return meaningsSet;
}

-(void)insertLanguage:(NSString *)name withObjectId:(NSString *)objectId {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM languages "
            "WHERE id_object = ?",
            objectId
        ];
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db executeUpdate:
            @"INSERT INTO languages "
            "(name, id_object) "
            "VALUES (?, ?)",
            name,
            objectId
        ];
    }];
}

- (void)insertMeaning:(NSString *)text
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM meanings "
            "WHERE id_object = ?",
            objectId
        ];
        [db executeUpdate:
            @"INSERT INTO meanings "
            "(meaning, id_object, id_language) "
            "VALUES (?, ?, ?)",
            text,
            objectId,
            languageId
        ];
    }];
}

- (void)insertWord:(NSString *)word
    withMeaning:(NSString *)meaningId
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM words "
            "WHERE id_object = ?",
            objectId
        ];
        [db executeUpdate:
            @"INSERT INTO words"
            "(word, id_meaning, id_language, id_object)"
            "VALUES (?, ?, ?, ?)",
            word,
            meaningId,
            languageId,
            objectId
        ];
    }];
}

- (void)insertCardWithWord:(NSString *)wordId
    falseMeaningOne:(NSString *)meaningOneId
    falseMeaningTwo:(NSString *)meaningTwoId
    withObjectId:(NSString *)objectId {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM cards "
            "WHERE id_object = ?",
            objectId
        ];
        [db executeUpdate:
            @"INSERT INTO cards"
            "(id_word, id_meaning_false_1, id_meaning_false_2, id_object)"
            "VALUES (?, ?, ?, ?)",
            wordId,
            meaningOneId,
            meaningTwoId,
            objectId
        ];
    }];
}







@end
