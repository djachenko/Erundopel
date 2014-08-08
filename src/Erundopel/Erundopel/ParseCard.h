//
//  ParseCard.h
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseWord.h"
#import "ParseMeaning.h"

@interface ParseCard : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) ParseWord *word;
@property (nonatomic, strong) ParseMeaning *meaning_false_1;
@property (nonatomic, strong) ParseMeaning *meaning_false_2;

@end
