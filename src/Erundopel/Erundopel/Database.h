//
//  Database.h
//  Erundopel
//
//  Created by Admin on 04/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

- (NSArray *)getAllFixedCards;
- (NSArray *)getAllMeanings;

- (void)insertLanguage:(NSString *)name
    withObjectId:(NSString *)objectId;

- (void)insertMeaning:(NSString *)text
    forLanguage:(NSString *)languageId
    withObjectId:(NSString *)objectId;

@end
