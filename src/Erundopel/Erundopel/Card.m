#import "Card.h"
#include <stdlib.h>


@implementation Card

- (instancetype)initWithArticle:(Article *)article falseMeaning:(Meaning *)meaning1 falseMeaning:
        (Meaning *)meaning2;
{
    self = [self init];

    if (self) {
        _word = article.word;

        _meanings = @[article.meaning, meaning1, meaning2];
        _rightMeaningIndex = 0;
    }

    return self;
}

- (void)shuffleMeanings {
    int oldRightMeaningIndex = self.rightMeaningIndex;
    
    self.rightMeaningIndex = arc4random() % 3;
    int falseMeaningIndexes[] = {
        (self.rightMeaningIndex + 1) % 3,
        (self.rightMeaningIndex + 2) % 3
    };
    
    NSMutableArray *newMeanings = [self.meanings mutableCopy];
    
    newMeanings[self.rightMeaningIndex] = self.meanings[oldRightMeaningIndex];
    newMeanings[falseMeaningIndexes[0]] = self.meanings[(oldRightMeaningIndex + 1) % 3];
    newMeanings[falseMeaningIndexes[1]] = self.meanings[(oldRightMeaningIndex + 2) % 3];
    
    _meanings = [NSArray arrayWithArray:newMeanings];
}

@end