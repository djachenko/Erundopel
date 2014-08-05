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

@interface Database ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation Database

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
            "meaning INTEGER,"
            "FOREIGN KEY(id_language) REFERENCES languages(id),"
            "FOREIGN KEY(meaning) REFERENCES meanings(id)"
            ")"
        ];
        
        // Cards (depends on Words)
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS cards ("
            "id INTEGER PRIMARY KEY,"
            "id_word INTEGER,"
            "meaning_false_1 INTEGER,"
            "meaning_false_2 INTEGER,"
            "FOREIGN KEY(id_word) REFERENCES words(id),"
            "FOREIGN KEY(meaning_false_1) REFERENCES meanings(id),"
            "FOREIGN KEY(meaning_false_1) REFERENCES meanings(id)"
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


- (NSArray *)getAllCards {
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM test_table;"];
        while ([s next]) {
            NSLog(@"%d, %@", [s intForColumn:@"id"], [s stringForColumn:@"name"]);
        }
    }];
    
    return nil;
}






@end
