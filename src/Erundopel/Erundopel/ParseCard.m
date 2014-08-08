//
//  ParseCard.m
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseCard.h"
#import <Parse/PFObject+Subclass.h>

@implementation ParseCard

+ (NSString *)parseClassName {
    return @"card";
}

@dynamic word;
@dynamic meaning_false_1;
@dynamic meaning_false_2;

@end
