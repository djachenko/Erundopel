//
//  ParseLanguage.m
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseLanguage.h"
#import <Parse/PFObject+Subclass.h>

@implementation ParseLanguage

+ (NSString *)parseClassName {
    return @"language";
}

@dynamic name;

@end
