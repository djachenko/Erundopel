#import "Card.h"


@implementation Card
{

}

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

@end