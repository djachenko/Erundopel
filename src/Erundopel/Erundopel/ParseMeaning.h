//
//  ParseMeaning.h
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseLanguage.h"

@interface ParseMeaning : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *meaning;
@property (nonatomic, strong) ParseLanguage *language;

@end
