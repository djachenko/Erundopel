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
    
    return self;
}

// only to be called from constructor
- (void)createScheme {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS words ("
            "id INTEGER PRIMARY KEY,"
            "word TEXT,"
            "id_language INTEGER,"
            "meaning_true INTEGER,"
            "meaning_false_1 INTEGER,"
            "meaning_false_2 INTEGER,"
            "FOREIGN KEY(id_language) REFERENCES languages(id),"
            "FOREIGN KEY(meaning_true) REFERENCES meanings(id),"
            "FOREIGN KEY(meaning_false_1) REFERENCES meanings(id),"
            "FOREIGN KEY(meaning_false_1) REFERENCES meanings(id)"
            ")"];
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
