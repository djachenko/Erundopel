#import "Word.h"


@implementation Word
{

}

- (instancetype)initWithText:(NSString *)text
{
    self = [self init];

    if (self) {
        _text = text;
    }

    return self;
}

@end