//
//  Database.h
//  Erundopel
//
//  Created by Admin on 04/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (NSArray *)getAllMeanings;

- (NSArray *)getRandomArticles:(unsigned int)amount;
- (NSSet *)getRandomMeanings:(unsigned int)amount;

- (void)wipeAllTables;

- (void)insertLanguage:(NSString *)name
    withObjectId:(NSString *)objectId;

- (void)insertMeaning:(NSString *)text
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId;

- (void)insertWord:(NSString *)word
    withMeaning:(NSString *)meaningId
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId;

- (void)insertCardWithWord:(NSString *)wordId
    falseMeaningOne:(NSString *)meaningOneId
    falseMeaningTwo:(NSString *)meaningTwoId
    withObjectId:(NSString *)objectId;

@end
