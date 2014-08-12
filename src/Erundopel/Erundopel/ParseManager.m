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
@property (nonatomic, weak) NSUserDefaults *userDefaults;

@end

@implementation ParseManager

static NSString *const kLastUpdateLanguage = @"LastUpdateLanguage";
static NSString *const kLastUpdateMeaning = @"LastUpdateMeaning";
static NSString *const kLastUpdateWord = @"LastUpdateWord";
static NSString *const kLastUpdateCard = @"LastUpdateCard";

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _db = [[Database alloc] init];
        _userDefaults = [NSUserDefaults standardUserDefaults];
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

- (void)initUpdateDates:(BOOL)forced {
    NSArray *keys = @[
        kLastUpdateLanguage,
        kLastUpdateMeaning,
        kLastUpdateWord,
        kLastUpdateCard
    ];
    
    for (NSString *key in keys) {
        if ([self getLastUpdateDateForKey:key] == nil || forced) {
            [self setLastUpdateDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]
                forKey:key];
        }
    }
}

- (void)downloadAll {
    [self initUpdateDates:NO];
    
    //[self.db wipeAllTables];
    [self downloadLanguages];
    [self downloadMeanings];
    [self downloadWords];
    [self downloadCards];
}

- (void)downloadLanguages {
    NSString *key = kLastUpdateLanguage;
    
    PFQuery *query = [ParseLanguage query];
    
    [query whereKey:@"updatedAt" greaterThan:[self getLastUpdateDateForKey:key]];
    
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu languages.", (unsigned long)objects.count);

            for (ParseLanguage *language in objects) {
                [self.db
                    insertLanguage:language.name
                    withObjectId:language.objectId
                ];
            }
            
            ParseLanguage *newestObject = objects.firstObject;
            
            [self setLastUpdateDateFromObject:newestObject forKey:key];
            
            NSLog(@"%@", [self getLastUpdateDateForKey:key]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadMeanings {
    NSString *key = kLastUpdateMeaning;

    PFQuery *query = [ParseMeaning query];
    
    [query whereKey:@"updatedAt" greaterThan:[self getLastUpdateDateForKey:key]];
    
    [query setLimit:1000];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu meanings.", (unsigned long)objects.count);

            for (ParseMeaning *meaning in objects) {
                [self.db
                    insertMeaning:meaning.meaning
                    forLanguage:meaning.language.objectId
                    withObjectId:meaning.objectId
                ];
            }
            
            ParseMeaning *newestObject = objects.firstObject;
            
            [self setLastUpdateDateFromObject:newestObject forKey:key];
            
            NSLog(@"%@", [self getLastUpdateDateForKey:key]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadWords {
    NSString *key = kLastUpdateWord;
    
    PFQuery *query = [ParseWord query];
    
    [query whereKey:@"updatedAt" greaterThan:[self getLastUpdateDateForKey:key]];
    
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu words.", (unsigned long)objects.count);

            for (ParseWord *word in objects) {
                [self.db
                    insertWord:word.word
                    withMeaning:word.meaning.objectId
                    forLanguage:word.language.objectId
                    withObjectId:word.objectId
                ];
            }
            
            ParseWord *newestObject = objects.firstObject;
            
            [self setLastUpdateDateFromObject:newestObject forKey:key];
            
            NSLog(@"%@", [self getLastUpdateDateForKey:key]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)downloadCards {
    NSString *key = kLastUpdateCard;
    
    PFQuery *query = [ParseCard query];
    
    [query whereKey:@"updatedAt" greaterThan:[self getLastUpdateDateForKey:key]];
    
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu cards.", (unsigned long)objects.count);

            for (ParseCard *card in objects) {
                [self.db
                    insertCardWithWord:card.word.objectId
                    falseMeaningOne:card.meaning_false_1.objectId
                    falseMeaningTwo:card.meaning_false_2.objectId
                    withObjectId:card.objectId
                ];
            }
            
            ParseCard *newestObject = objects.firstObject;
            
            [self setLastUpdateDateFromObject:newestObject forKey:key];
            
            NSLog(@"Card last update: %@", [self getLastUpdateDateForKey:key]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)setLastUpdateDate:(NSDate *)updateDate
    forKey:(NSString *)key {
    [self.userDefaults
        setObject:updateDate
        forKey:key];
    
    [self.userDefaults synchronize];
}

- (NSDate *)getLastUpdateDateForKey:(NSString *)key {
    return [self.userDefaults objectForKey:key];
}

- (void)setLastUpdateDateFromObject:(PFObject *)object
    forKey:(NSString *)key {
        if (!!object) {
            [self setLastUpdateDate:object.updatedAt
                forKey:key];
        }
}

@end
