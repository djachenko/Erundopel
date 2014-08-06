//
//  Database.m
//  Erundopel
//
//  Created by Admin on 04/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Meaning.h"
#import "Word.h"
#import "Article.h"
#import "Card.h"

@interface Database ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation Database

NSString *tableNameLanguages         = @"languages";
NSString *tableNameMeanings          = @"meanings";
NSString *tableNameWords             = @"words";
NSString *tableNameCards             = @"cards";
NSString *tableNameMeaningPopularity = @"meaning_popularity";

NSString *queryDropTable = @"DROP TABLE ?";

- (instancetype)init {
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
//        [db executeUpdate:@"DROP TABLE languages"];
//        [db executeUpdate:@"DROP TABLE meanings"];
//        [db executeUpdate:@"DROP TABLE words"];
//        [db executeUpdate:@"DROP TABLE cards"];
//        [db executeUpdate:@"DROP TABLE meaning_popularity"];
        
        // Languages (independent)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS languages ("
            "id INTEGER PRIMARY KEY,"
            "name TEXT"
            ")"
        ];
        
        // Meanings (depends on Languages)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS meanings ("
            "id INTEGER PRIMARY KEY,"
            "meaning TEXT,"
            "id_language INTEGER,"
            "FOREIGN KEY(id_language) REFERENCES languages(id)"
            ")"
        ];
        
        // Words (depends on Languages and Meanings)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS words ("
            "id INTEGER PRIMARY KEY,"
            "word TEXT,"
            "id_language INTEGER,"
            "id_meaning INTEGER,"
            "FOREIGN KEY(id_language) REFERENCES languages(id),"
            "FOREIGN KEY(id_meaning) REFERENCES meanings(id)"
            ")"
        ];
        
        // Cards (depends on Words)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS cards ("
            "id INTEGER PRIMARY KEY,"
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
    [self fillWithTestContent];
}

- (void)fillWithTestContent {
    [self.queue inDatabase:^(FMDatabase *db) {
        // languages
        [db executeUpdate:@"DELETE FROM languages"];
        
        [db executeUpdate:@"INSERT INTO languages (name) VALUES (?)", @"russian"];
        [db executeUpdate:@"INSERT INTO languages (name) VALUES (?)", @"english"];
        
        // meanings
        [db executeUpdate:@"DELETE FROM meanings"];
        
        NSArray *meanings = @[
            @"другое название ягоды голубики",
            @"гладкоствольное, фитильное дульнозарядное ружьё",
            @"неправильное определение",
            @"определение от совсем другого слова",
            @"вообще что-то странное и не к месту",
            @"имперский звездолет класса \"планетарный разрушитель\"",
            @"большой полосатый мух",
            @"кто-то хитрый и большой"
        ];
        
        for (NSString *meaning in meanings) {
            [db executeUpdate:@"INSERT INTO meanings (meaning, id_language) VALUES (?, ?)", meaning, [NSNumber numberWithInt:1]];
        }
        
        // words
        [db executeUpdate:@"DELETE FROM words"];
        
        [db executeUpdate:@"INSERT INTO words (word, id_meaning, id_language) VALUES (?, ?, ?)", @"гонобобель", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1]];
        [db executeUpdate:@"INSERT INTO words (word, id_meaning, id_language) VALUES (?, ?, ?)", @"аркебуза", [NSNumber numberWithInt:2], [NSNumber numberWithInt:1]];
        
        // cards
        [db executeUpdate:@"DELETE FROM cards"];
        
        [db executeUpdate:
            @"INSERT INTO cards (id_word, id_meaning_false_1, id_meaning_false_2) VALUES (?, ?, ?)",
            [NSNumber numberWithInt:1],
            [NSNumber numberWithInt:5],
            [NSNumber numberWithInt:6]];
        [db executeUpdate:
            @"INSERT INTO cards (id_word, id_meaning_false_1, id_meaning_false_2) VALUES (?, ?, ?)",
            [NSNumber numberWithInt:2],
            [NSNumber numberWithInt:7],
            [NSNumber numberWithInt:8]];
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
        Article *article = [self getArticleForWordById:[cardDict[@"id_word"] intValue]];
        NSArray *meanings = @[
            [self getMeaningById:[cardDict[@"id_meaning_false_1"] intValue]],
            [self getMeaningById:[cardDict[@"id_meaning_false_2"] intValue]]
        ];
        
        Card *card = [[Card alloc]
            initWithArticle:article
            falseMeaning:meanings[0]
            falseMeaning:meanings[1]
        ];
        
        [mutableArray addObject:card];
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (Article *)getArticleForWordById:(int)wordId
{
    Word *__block word = nil;
    Meaning *__block meaning = nil;
    
    __block int meaningId = 0;
    
    // create Word and get meaning id
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *wordResult = [db executeQuery:
            @"SELECT word, id_meaning "
            "FROM words "
            "WHERE words.id = ?",
            [NSNumber numberWithInt:wordId]
        ];
        
        if ([wordResult next]) {
            NSString *wordString = [wordResult stringForColumn:@"word"];
            word = [[Word alloc] initWithText:wordString];
            
            meaningId = [wordResult intForColumn:@"id_meaning"];
            [wordResult close];
        }
    }];
    
    meaning = [self getMeaningById:meaningId];
    
    return [[Article alloc] initWithWord:word meaning:meaning];
}

- (Meaning *)getMeaningById:(int)meaningId
{
    Meaning *__block meaning = nil;
    
    // create Word and get meaning id
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *meaningResult = [db executeQuery:
            @"SELECT meaning "
            "FROM meanings "
            "WHERE meanings.id = ?",
            [NSNumber numberWithInt:meaningId]
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
    return [NSArray arrayWithArray:mutableArray];
}

- (void)addMeaning:(Meaning *)meaning
    forLanguage:(int)languageId {
    [self.queue inDatabase:^(FMDatabase *db) {
       // [db executeUpdate:@"INSERT INTO meanings, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
    }];
}







@end
