//
//  ParseManager.m
//  Erundopel
//
//  Created by Admin on 07/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseManager.h"
#import "Database.h"
#import "Parse/Parse.h"

@interface ParseManager ()

@property (nonatomic, strong) Database *db;

@end

@implementation ParseManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _db = [[Database alloc] init];
    }
    
    return self;
}

- (void)downloadAll {
    [self downloadLanguages];
    [self downloadMeanings];
}

- (void)downloadLanguages {
    PFQuery *query = [PFQuery queryWithClassName:@"language"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d languages.", objects.count);

            // Do something with the found objects
            for (PFObject *object in objects) {
                [self.db insertLanguage:object[@"name"] withObjectId:object.objectId];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#warning only 100 objects retrieved!

- (void)downloadMeanings {
    PFQuery *query = [PFQuery queryWithClassName:@"meaning"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d meanings.", objects.count);

            // Do something with the found objects
            for (PFObject *object in objects) {
                [self.db
                    insertMeaning:object[@"meaning"]
                    forLanguage:((PFObject *)object[@"language"]).objectId
                    withObjectId:object.objectId
                ];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
