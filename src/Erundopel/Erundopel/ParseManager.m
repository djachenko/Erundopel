//
//  ParseManager.m
//  Erundopel
//
//  Created by Admin on 07/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseManager.h"
#import "Database.h"
#import <Parse/Parse.h>
#import "ParseCard.h"
#import "ParseWord.h"
#import "ParseMeaning.h"
#import "ParseLanguage.h"

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

#warning Unresolved TODO mark!
/**
 *  TODO: handle the limit for one database request
 *  Currently one query to Parse can return up to 1000 objects.
 *  It can be handled with query.limit and query.skip properties.
 *  Just need to count all objects in table,
 *  and execute enough queries to get all the data.
 */

- (void)downloadAll {
    [self.db wipeAllTables];
    [self downloadLanguages];
    [self downloadMeanings];
    [self downloadWords];
    [self downloadCards];
}

- (void)downloadLanguages {
    PFQuery *query = [ParseLanguage query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d languages.", objects.count);

            for (ParseLanguage *language in objects) {
                [self.db
                    insertLanguage:language.name
                    withObjectId:language.objectId
                ];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadMeanings {
    PFQuery *query = [ParseMeaning query];
    
    [query setLimit:1000];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d meanings.", objects.count);

            for (ParseMeaning *meaning in objects) {
                [self.db
                    insertMeaning:meaning.meaning
                    forLanguage:meaning.language.objectId
                    withObjectId:meaning.objectId
                ];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadWords {
    PFQuery *query = [ParseWord query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d words.", objects.count);

            for (ParseWord *word in objects) {
                [self.db
                    insertWord:word.word
                    withMeaning:word.meaning.objectId
                    forLanguage:word.language.objectId
                    withObjectId:word.objectId
                ];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadCards {
    PFQuery *query = [ParseCard query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d cards.", objects.count);

            for (ParseCard *card in objects) {
                [self.db
                    insertCardWithWord:card.word.objectId
                    falseMeaningOne:card.meaning_false_1.objectId
                    falseMeaningTwo:card.meaning_false_2.objectId
                    withObjectId:card.objectId
                ];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
