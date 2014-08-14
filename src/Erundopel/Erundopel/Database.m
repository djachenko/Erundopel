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

- (NSString *)getTextFromFile:(NSString *)filePath {
   return [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
}

// only to be called from constructor
- (void)createScheme
{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"dbScheme" ofType: @"sql"];
 
    NSString *createQuery = [self getTextFromFile:path];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeStatements:createQuery];
    }];
}

- (void)dropAllTables
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DROP TABLE languages"];
        [db executeUpdate:@"DROP TABLE meanings"];
        [db executeUpdate:@"DROP TABLE words"];
        [db executeUpdate:@"DROP TABLE cards"];
        [db executeUpdate:@"DROP TABLE meaning_popularity"];
    }];
}

- (void)wipeAllTables
{
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

- (NSArray *)getRandomArticles:(unsigned int)amount
{
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

- (NSSet *)getRandomMeanings:(unsigned int)amount
{
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
    [self.queue inDatabase:^(FMDatabase *db)
{
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
    withObjectId:(NSString *)objectId
    sync:(SyncState)sync {
    [self.queue inDatabase:^(FMDatabase *db)
{
        [db executeUpdate:
            @"DELETE FROM meanings "
            "WHERE id_object = ?",
            objectId
        ];
        [db executeUpdate:
            @"INSERT INTO meanings "
            "(meaning, id_object, id_language, sync) "
            "VALUES (?, ?, ?, ?)",
            text,
            objectId,
            languageId,
            [NSNumber numberWithInteger:sync]
        ];
    }];
}

- (void)insertWord:(NSString *)word
    withMeaning:(NSString *)meaningId
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId
    sync:(SyncState)sync
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM words "
            "WHERE id_object = ?",
            objectId
        ];
        [db executeUpdate:
            @"INSERT INTO words"
            "(word, id_meaning, id_language, id_object, sync)"
            "VALUES (?, ?, ?, ?, ?)",
            word,
            meaningId,
            languageId,
            objectId,
            [NSNumber numberWithInteger:sync]
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

- (NSString *)getLanguageObjectIdBytName:(NSString *)name
{
    NSString *__block languageObjectId = nil;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *languageResult = [db executeQuery:
            @"SELECT id_object "
            "FROM languages "
            "WHERE name = ? "
            "LIMIT 1",
            name
        ];
        
        if ([languageResult next]) {
            languageObjectId = [languageResult stringForColumn:@"id_object"];
            [languageResult close];
        }
    }];
    
    return languageObjectId;
}

- (NSString *)getTempObjectIdForEntity:(NSString *)entity
{
    NSString *__block tempObjectId = nil;
    
    NSString *queryString = [NSString stringWithFormat:
            @"SELECT max(id) as max_id "
            "FROM %@",
            entity
    ];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *idResult = [db executeQuery:queryString];
        
        if ([idResult next]) {
            int maxId = [idResult intForColumn:@"max_id"];
            tempObjectId = [NSString stringWithFormat:@"temp%d", maxId];
            [idResult close];
        }
    }];
    
    return tempObjectId;
}

- (void)addArticle:(Article *)article
{
    NSString *languageObjectId = [self getLanguageObjectIdBytName:@"russian"];
    
    NSString *tempMeaningObjectId = [self getTempObjectIdForEntity:tableNameMeanings];
    
    [self insertMeaning:article.meaning.text
        forLanguage:languageObjectId
        withObjectId:tempMeaningObjectId
        sync:NO
    ];
    
    NSString *tempWordObjectId = [self getTempObjectIdForEntity:tableNameWords];
    
    [self insertWord:article.word.text
        withMeaning:tempMeaningObjectId
        forLanguage:languageObjectId
        withObjectId:tempWordObjectId
        sync:NO
    ];
}

- (void)addMeaning:(Meaning *)meaning
{
    NSString *languageObjectId = [self getLanguageObjectIdBytName:@"russian"];
    
    NSString *tempMeaningObjectId = [self getTempObjectIdForEntity:tableNameMeanings];
    
    [self insertMeaning:meaning.text
        forLanguage:languageObjectId
        withObjectId:tempMeaningObjectId
        sync:NO
    ];
}

- (BOOL)hasWordWithValue:(NSString *)value
{
    return [self hasEntity:tableNameWords
        withField:@"word"
        equalTo:value
    ];}

- (BOOL)hasMeaningWithValue:(NSString *)value
{
    return [self hasEntity:tableNameMeanings
        withField:@"meaning"
        equalTo:value
    ];
}

- (BOOL)hasEntity:(NSString *)entity
    withField:(NSString *)fieldName
    equalTo:(NSString *)value
{
    BOOL __block result = NO;
    
    NSString *query = [NSString
        stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",
        entity,
        fieldName
    ];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:query, value];
        
        if ([rs next]) {
            if ([rs hasAnotherRow]) {
                result = YES;
            }
        }
        [rs close];
    }];
    
    return result;
}

- (NSArray *)getAllNewArticles
{
    NSMutableArray *newArticles = [[NSMutableArray alloc] init];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *newWordsResult = [db executeQuery:
            @"SELECT * "
            "FROM words "
            "WHERE sync = ?",
            [NSNumber numberWithInt:SyncStateNotSynced]
        ];
        
        while ([newWordsResult next]) {
            [result addObject:[newWordsResult resultDictionary]];
        }
        [newWordsResult close];
    }];
    
    for (NSDictionary *resultRow in result) {
        NSString *wordObjectId = resultRow[@"id_object"];
        NSString *meaningObjectId = resultRow[@"id_meaning"];
        Article *article = [self getArticleForWordById:wordObjectId];
        [newArticles addObject:@{
            @"word_id": wordObjectId,
            @"meaning_id": meaningObjectId,
            @"value": article
        }];
    }
    
    return newArticles;
}

- (NSArray *)getAllNewMeanings
{
    NSMutableArray * newMeanings = [[NSMutableArray alloc] init];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *newMeaningsResult = [db executeQuery:
            @"SELECT * "
            "FROM meanings "
            "WHERE sync = ?",
            [NSNumber numberWithInt:SyncStateNotSynced]
        ];
        
        while ([newMeaningsResult next]) {
            [result addObject:[newMeaningsResult resultDictionary]];
        }
        [newMeaningsResult close];
    }];

    for (NSDictionary *resultRow in result) {
        NSString *meaningObjectId = resultRow[@"id_object"];
        Meaning *meaning = [self getMeaningByObjectId:meaningObjectId];
        [newMeanings addObject:@{
            @"meaning_id": meaningObjectId,
            @"value": meaning
        }];
    }
    
    return newMeanings;
}

- (void)setMeaningObjectId:(NSString *)newObjectId
    forWordByObjectId:(NSString *)wordObjectId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"UPDATE words "
            "SET id_meaning = ? "
            "WHERE id_object = ?",
            newObjectId,
            wordObjectId
        ];
    }];
}

- (void)setNewWordObjectId:(NSString *)newObjectId
    byObjectId:(NSString *)oldObjectId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"UPDATE words "
            "SET id_object = ? "
            "WHERE id_object = ?",
            newObjectId,
            oldObjectId
        ];
    }];
}

- (void)setNewMeaningObjectId:(NSString *)newObjectId
    byObjectId:(NSString *)oldObjectId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"UPDATE meanings "
            "SET id_object = ? "
            "WHERE id_object = ?",
            newObjectId,
            oldObjectId
        ];
    }];
}

- (void)setSyncState:(SyncState)syncState forEntity:(NSString *)entity byObjectId:(NSString *)objectId
{
    NSString *query = [NSString stringWithFormat:
        @"UPDATE %@ "
        "SET sync = ? "
        "WHERE id_object = ?",
        entity
    ];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query,
            [NSNumber numberWithInt:syncState],
            objectId
        ];
    }];
}

-(void)setSyncState:(SyncState)syncState forWordByObjectId:(NSString *)objectId
{
    [self setSyncState:syncState forEntity:tableNameWords byObjectId:objectId];
}

- (void)setSyncState:(SyncState)syncState forMeaningByObjectId:(NSString *)objectId
{
    [self setSyncState:syncState forEntity:tableNameMeanings byObjectId:objectId];
}

// delete methods
- (void)deleteEntity:(NSString *)entity
    byObjectId:(NSString *)objectId
{
    NSString *query = [NSString stringWithFormat:
        @"DELETE FROM %@ "
        "WHERE id_object = ?",
        entity
    ];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query,
            objectId
        ];
    }];
}

- (void)deleteLanguageByObjectId:(NSString *)objectId
{
    [self deleteEntity:tableNameLanguages byObjectId:objectId];
}

- (void)deleteMeaningByObjectId:(NSString *)objectId
{
    [self deleteEntity:tableNameMeanings byObjectId:objectId];
}

- (void)deleteWordByObjectId:(NSString *)objectId
{
    [self deleteEntity:tableNameWords byObjectId:objectId];
}

- (void)deleteCardByObjectId:(NSString *)objectId
{
    [self deleteEntity:tableNameCards byObjectId:objectId];
}


@end
