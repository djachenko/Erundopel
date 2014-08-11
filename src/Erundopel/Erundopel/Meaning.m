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

- (instancetype)copyWithZone:(NSZone *)zone
{
    Meaning *copy = [[Meaning alloc] initWithText:self.text];
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{<Meaning>: %@}", self.text];
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return false;
    }
    Meaning *other = (Meaning *)object;
    return [self.text isEqual:other.text];
}

- (NSUInteger)hash {
    return [self.text hash] * 13;
}


@end