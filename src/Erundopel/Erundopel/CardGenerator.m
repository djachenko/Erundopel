//
//  CardGenerator.m
//  Erundopel
//
//  Created by Admin on 11/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "CardGenerator.h"
#import "Database.h"

@interface CardGenerator ()

@property (nonatomic, strong) Database *db;
@property (nonatomic, strong) NSArray *cards;
@property (nonatomic) int cardIndex;

@end

@implementation CardGenerator

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _db = [[Database alloc] init];
        _cards = nil;
        _cardIndex = 0;
    }
    
    return self;
}

- (Card *)nextCard {
    if (self.cards == nil) {
        self.cards = [self.db getAllFixedCards];
    }
    
    if ([self.cards count] <= 0) {
        return nil;
    }
    
    if (self.cardIndex >= [self.cards count]) {
        self.cardIndex = 0;
    }
    
    return self.cards[self.cardIndex++];
}

@end
