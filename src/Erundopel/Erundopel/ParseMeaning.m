//
//  ParseMeaning.m
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseMeaning.h"
#import <Parse/PFObject+Subclass.h>

@implementation ParseMeaning

+ (NSString *)parseClassName {
    return @"meaning";
}

@dynamic meaning;
@dynamic language;

@end
