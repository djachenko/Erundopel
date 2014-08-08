//
//  ParseWord.h
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseMeaning.h"
#import "ParseLanguage.h"

@interface ParseWord : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) ParseMeaning *meaning;
@property (nonatomic, strong) ParseLanguage *language;


@end
