#import "Meaning.h"


@implementation Meaning
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