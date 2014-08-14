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
#import "Article.h"



@interface ParseManager ()

@property (nonatomic, strong) Database *db;
@property (nonatomic, weak) NSUserDefaults *userDefaults;

@end

@implementation ParseManager

static NSString *const kLastUpdateLanguage = @"LastUpdateLanguage";
static NSString *const kLastUpdateMeaning = @"LastUpdateMeaning";
static NSString *const kLastUpdateWord = @"LastUpdateWord";
static NSString *const kLastUpdateCard = @"LastUpdateCard";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _db = [Database sharedInstance];
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

- (void)initUpdateDates:(BOOL)forced
{
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

- (void)handleQuery:(PFQuery *)query
    withKey:(NSString *)key
    block:(void (^)(NSArray *objects, NSError *error))block
{
    [query whereKey:@"updatedAt" greaterThan:[self getLastUpdateDateForKey:key]];
    
    [query orderByDescending:@"updatedAt"];
    
    [query setLimit:1000];
    
    [query findObjectsInBackgroundWithBlock:block];

}

- (void)downloadLanguages
{
    NSString *key = kLastUpdateLanguage;
    
    PFQuery *query = [ParseLanguage query];
    
    [self handleQuery:query
        withKey:key
        block:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %lu languages.", (unsigned long)objects.count);

                for (ParseLanguage *language in objects) {
                    if (language.name == nil) {
                        [self.db deleteLanguageByObjectId:language.objectId];
                    } else {
                        [self.db
                            insertLanguage:language.name
                            withObjectId:language.objectId
                        ];
                    }
                }
                
                ParseLanguage *newestObject = objects.firstObject;
                
                [self setLastUpdateDateFromObject:newestObject forKey:key];
                
                NSLog(@"%@", [self getLastUpdateDateForKey:key]);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}

- (void)downloadMeanings
{
    NSString *key = kLastUpdateMeaning;

    PFQuery *query = [ParseMeaning query];
    
    [self handleQuery:query
        withKey:key
        block:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %lu meanings.", (unsigned long)objects.count);

                for (ParseMeaning *meaning in objects) {
                    if (meaning.meaning == nil) {
                        [self.db deleteMeaningByObjectId:meaning.objectId];
                    } else {
                        [self.db
                            insertMeaning:meaning.meaning
                            forLanguage:meaning.language.objectId
                            withObjectId:meaning.objectId
                            sync:SyncStateSynced
                        ];
                    }
                }
                
                ParseMeaning *newestObject = objects.firstObject;
                
                [self setLastUpdateDateFromObject:newestObject forKey:key];
                
                NSLog(@"%@", [self getLastUpdateDateForKey:key]);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}

- (void)downloadWords
{
    NSString *key = kLastUpdateWord;
    
    PFQuery *query = [ParseWord query];
    
    [self handleQuery:query
        withKey:key
        block:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %lu words.", (unsigned long)objects.count);

                for (ParseWord *word in objects) {
                    if (word.word == nil) {
                        [self.db deleteWordByObjectId:word.objectId];
                    } else {
                        [self.db
                            insertWord:word.word
                            withMeaning:word.meaning.objectId
                            forLanguage:word.language.objectId
                            withObjectId:word.objectId
                            sync:SyncStateSynced
                        ];
                    }
                }
                
                ParseWord *newestObject = objects.firstObject;
                
                [self setLastUpdateDateFromObject:newestObject forKey:key];
                
                NSLog(@"%@", [self getLastUpdateDateForKey:key]);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}

- (void)downloadCards
{
    NSString *key = kLastUpdateCard;
    
    PFQuery *query = [ParseCard query];
    
    [self handleQuery:query
        withKey:key
        block:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %lu cards.", (unsigned long)objects.count);

                for (ParseCard *card in objects) {
                    if (card.word == nil) {
                        [self.db deleteCardByObjectId:card.objectId];
                    } else {
                        [self.db
                            insertCardWithWord:card.word.objectId
                            falseMeaningOne:card.meaning_false_1.objectId
                            falseMeaningTwo:card.meaning_false_2.objectId
                            withObjectId:card.objectId
                        ];
                    }
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
    forKey:(NSString *)key
{
    [self.userDefaults
        setObject:updateDate
        forKey:key];
    
    [self.userDefaults synchronize];
}

- (NSDate *)getLastUpdateDateForKey:(NSString *)key
{
    return [self.userDefaults objectForKey:key];
}

- (void)setLastUpdateDateFromObject:(PFObject *)object
    forKey:(NSString *)key
{
        if (!!object) {
            [self setLastUpdateDate:object.updatedAt
                forKey:key];
        }
}

- (void)uploadAll
{
    [self uploadNewWords];
    [self uploadNewMeanings];
}

- (void)uploadNewWords
{
    NSArray *articleDictionaries = [self.db getAllNewArticles];
    
    for (NSDictionary *dictionary in articleDictionaries) {
        ParseMeaning *meaning = [[ParseMeaning alloc] init];
        
        Article *article = dictionary[@"value"];
        
        meaning.meaning = article.meaning.text;
        
        ParseLanguage *language = (ParseLanguage *)[PFObject
            objectWithoutDataWithClassName:@"language"
            objectId:[self.db getLanguageObjectIdBytName:@"russian"]
        ];
        
        meaning.language = language;
        
        ParseWord *word = [[ParseWord alloc] init];
        word.word = article.word.text;
        word.meaning = meaning;
        word.language = language;
        
        
        NSString *wordObjectId = dictionary[@"word_id"];
        NSString *meaningObjectId = dictionary[@"meaning_id"];
        
        [self.db setSyncState:SyncStateStarted forMeaningByObjectId:meaningObjectId];
        [self.db setSyncState:SyncStateStarted forWordByObjectId:wordObjectId];
        
        [word saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *newMeaningObjectId = word.meaning.objectId;
                NSString *newWordObjectId = word.objectId;
                
                // update objectIds
                [self.db setNewMeaningObjectId:newMeaningObjectId byObjectId:meaningObjectId];
                [self.db setNewWordObjectId:newWordObjectId byObjectId:wordObjectId];
                [self.db setMeaningObjectId:newMeaningObjectId forWordByObjectId:newWordObjectId];
            
                // update sync state
                [self.db setSyncState:SyncStateSynced forMeaningByObjectId:newWordObjectId];
                [self.db setSyncState:SyncStateSynced forWordByObjectId:newMeaningObjectId];
            } else {
                [self.db setSyncState:SyncStateNotSynced forMeaningByObjectId:meaningObjectId];
                [self.db setSyncState:SyncStateNotSynced forWordByObjectId:wordObjectId];
            }
        }];
    }
}

- (void)uploadNewMeanings
{
    NSArray *meaningDictionaries = [self.db getAllNewMeanings];
    
    for (NSDictionary *dictionary in meaningDictionaries) {
        ParseMeaning *parseMeaning = [[ParseMeaning alloc] init];
        
        Meaning *meaning = dictionary[@"value"];
        
        parseMeaning.meaning = meaning.text;
        
        ParseLanguage *language = (ParseLanguage *)[PFObject
            objectWithoutDataWithClassName:@"language"
            objectId:[self.db getLanguageObjectIdBytName:@"russian"]
        ];
        
        parseMeaning.language = language;
    
        NSString *meaningObjectId = dictionary[@"meaning_id"];
        
        [self.db setSyncState:SyncStateStarted forMeaningByObjectId:meaningObjectId];
        
        [parseMeaning saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *newMeaningObjectId = parseMeaning.objectId;
                
                // update objectId
                [self.db setNewMeaningObjectId:newMeaningObjectId byObjectId:meaningObjectId];
            
                // update sync state
                [self.db setSyncState:SyncStateSynced forMeaningByObjectId:newMeaningObjectId];
            } else {
                [self.db setSyncState:SyncStateNotSynced forMeaningByObjectId:meaningObjectId];
            }
        }];
    }
}

@end
