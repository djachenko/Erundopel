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
@property (nonatomic) CardGeneratorMode mode;

@end

@implementation CardGenerator

- (instancetype)initWithMode:(CardGeneratorMode)mode
{
    self = [super init];
    
    if (self) {
        _db = [Database sharedInstance];
        _cards = nil;
        _cardIndex = 0;
        _mode = mode;
    }
    
    return self;
}

- (Card *)nextCard {
    
    switch (self.mode) {
        case CardGeneratorModeFixed: {
            if (self.cards == nil) {
                self.cards = [self.db getAllFixedCards];
            }
            
            if ([self.cards count] <= 0) {
                return nil;
            }
            
            if (self.cardIndex >= [self.cards count]) {
                self.cardIndex = 0;
            }
            
            [self.db getRandomArticles:5];
            
            return self.cards[self.cardIndex++];
        }
        
        case CardGeneratorModeRandom: {
            if (self.cards == nil) {
                self.cards = [self generateRandomCards];
            }
            
            if ([self.cards count] <= 0) {
                return nil;
            }
            
            if (self.cardIndex >= [self.cards count]) {
                self.cards = [self generateRandomCards];
                self.cardIndex = 0;
            }
            
            return self.cards[self.cardIndex++];
        }
        
        default:
            break;
    }
    
    return nil;
}

- (NSArray *)generateRandomCards {
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    NSArray *articles = [self.db getRandomArticles:5];
    NSSet *meanings = [self.db getRandomMeanings:5*3];
    NSMutableSet *mutableMeanings = [meanings mutableCopy];
    
    for (Article *article in articles) {
        [mutableMeanings removeObject:article.meaning];
    }
    
    NSEnumerator *meaningEnumerator = [mutableMeanings objectEnumerator];
    
    for (Article *article in articles) {
        Card *card = [[Card alloc]
            initWithArticle:article
            falseMeaning:[meaningEnumerator nextObject]
            falseMeaning:[meaningEnumerator nextObject]
        ];
        [cards addObject:card];
    }
    
    return [NSArray arrayWithArray:cards];
}

@end
