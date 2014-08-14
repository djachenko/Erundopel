//
//  Database.h
//  Erundopel
//
//  Created by Admin on 04/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Article;
@class Word;
@class Meaning;

typedef NS_ENUM(NSUInteger, SyncState) {
    SyncStateNotSynced = 0,
    SyncStateStarted = 1,
    SyncStateSynced = 2
};


@interface Database : NSObject

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable(
    "alloc not available, call sharedInstance instead"
)));
-(instancetype) init __attribute__((unavailable(
    "init not available, call sharedInstance instead"
)));
+(instancetype) new __attribute__((unavailable(
    "new not available, call sharedInstance instead"
)));

- (NSArray *)getAllFixedCards;

- (NSArray *)getRandomArticles:(unsigned int)amount;
- (NSSet *)getRandomMeanings:(unsigned int)amount;

- (NSArray *)getAllNewArticles;
- (NSArray *)getAllNewMeanings;

- (NSString *)getLanguageObjectIdBytName:(NSString *)name;

- (BOOL)hasWordWithValue:(NSString *)value;
- (BOOL)hasMeaningWithValue:(NSString *)value;

- (void)wipeAllTables;

- (void)insertLanguage:(NSString *)name
    withObjectId:(NSString *)objectId;

- (void)insertMeaning:(NSString *)text
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId
    sync:(SyncState)sync;

- (void)insertWord:(NSString *)word
    withMeaning:(NSString *)meaningId
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId
    sync:(SyncState)sync;

- (void)insertCardWithWord:(NSString *)wordId
    falseMeaningOne:(NSString *)meaningOneId
    falseMeaningTwo:(NSString *)meaningTwoId
    withObjectId:(NSString *)objectId;

// add entity methods (for user input)
- (void)addArticle:(Article *)article;
- (void)addMeaning:(Meaning *)meaning;

// change objectId methods
- (void)setMeaningObjectId:(NSString *)newObjectId
    forWordByObjectId:(NSString *)wordObjectId;
- (void)setNewMeaningObjectId:(NSString *)newObjectId
    byObjectId:(NSString *)oldObjectId;
- (void)setNewWordObjectId:(NSString *)newObjectId
    byObjectId:(NSString *)oldObjectId;

// set sync state methods
- (void)setSyncState:(SyncState)syncState
    forWordByObjectId:(NSString *)objectId;
- (void)setSyncState:(SyncState)syncState
    forMeaningByObjectId:(NSString *)objectId;

// delete row by objectId
- (void)deleteLanguageByObjectId:(NSString *)objectId;
- (void)deleteMeaningByObjectId:(NSString *)objectId;
- (void)deleteWordByObjectId:(NSString *)objectId;
- (void)deleteCardByObjectId:(NSString *)objectId;


@end
