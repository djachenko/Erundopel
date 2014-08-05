#import "Article.h"


@implementation Article
{

}
- (instancetype)initWithWord:(Word *)word meaning:(Meaning *)meaning
{
    self = [self init];

    if (self) {
        _word = word;
        _meaning = meaning;
    }

    return self;
}

@end