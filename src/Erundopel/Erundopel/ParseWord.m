//
//  ParseWord.m
//  Erundopel
//
//  Created by Admin on 08/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "ParseWord.h"
#import <Parse/PFObject+Subclass.h>

@implementation ParseWord

+ (NSString *)parseClassName {
    return @"word";
}

@dynamic word;
@dynamic meaning;
@dynamic language;

@end
