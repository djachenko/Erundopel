#import "Meaning.h"


@implementation Meaning
{

}

@synthesize objectId;

- (instancetype)initWithText:(NSString *)text
{
    self = [self init];

    if (self) {
        _text = text;
    }

    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    Meaning *copy = [[Meaning alloc] initWithText:self.text];
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{<Meaning>: %@}", self.text];
}


@end