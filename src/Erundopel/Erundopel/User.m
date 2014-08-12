#import "User.h"

@interface User()

@end

@implementation User

- (instancetype)initWithName:(NSString *)name
{
    NSLog(@"init %@", name);

    self = [self initWithName:name statTotal:0 guessed:0];

    return self;
}

- (instancetype)initWithName:(NSString *)name statTotal:(NSInteger)total guessed:(NSInteger)guessed
{
    self = [self init];

    if (self) {


        _name = name;
        _total = total;
        _guessed = guessed;
    }

    return self;
}

- (void)guessedRight:(BOOL)state
{
    if (state) {
        self.guessed++;
    }

    self.total++;


    NSLog(@"|%@|:\nguessed: %d\ntotal %d\n", self.name, self.guessed, self.total);
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"UserName"];
    [coder encodeInteger:self.guessed forKey:@"UserGuessed"];
    [coder encodeInteger:self.total forKey:@"UserTotal"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];

    if (self) {
        _name = [coder decodeObjectForKey:@"UserName"];

        _guessed = [coder decodeIntegerForKey:@"UserGuessed"];

        NSLog(@"decode %i\n", _guessed);
        _total = [coder decodeIntegerForKey:@"UserTotal"];
    }

    return self;
}


@end