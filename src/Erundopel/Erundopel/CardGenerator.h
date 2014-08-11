//
//  CardGenerator.h
//  Erundopel
//
//  Created by Admin on 11/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef NS_ENUM(NSUInteger, CardGeneratorMode) {
    CardGeneratorModeFixed,
    CardGeneratorModeRandom
};

@interface CardGenerator : NSObject

- (instancetype)initWithMode:(CardGeneratorMode)mode;

- (Card *)nextCard;

@end
