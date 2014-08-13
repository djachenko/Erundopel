#import "User.h"
#import "NSString+Hashable.h"

@interface User()

@end

@implementation User

- (instancetype)initWithName:(NSString *)name password:(NSString *)password
{
    self = [self initWithName:name password:password statTotal:0 guessed:0];

    return self;
}

- (instancetype)initWithName:(NSString *)name password:(NSString *)password statTotal:(NSInteger)total guessed:(NSInteger)guessed
{
    self = [self init];

    if (self) {
        _name = name;
        _password = [password hashStringWithSalt:salt];
        _total = total;
        _guessed = guessed;
    }

    return self;
}

- (void)setPassword:(NSString *)password
{
    _password = [password hashStringWithSalt:salt];
}

- (void)guessedRight:(BOOL)state
{
    if (state) {
        self.guessed++;
    }

    self.total++;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"UserName"];
    [coder encodeInteger:self.guessed forKey:@"UserGuessed"];
    [coder encodeInteger:self.total forKey:@"UserTotal"];
    [coder encodeObject:self.password forKey:@"UserPassword"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];

    if (self) {
        _name = [coder decodeObjectForKey:@"UserName"];
        _password = [coder decodeObjectForKey:@"UserPassword"];
        _guessed = [coder decodeIntegerForKey:@"UserGuessed"];
        _total = [coder decodeIntegerForKey:@"UserTotal"];
    }

    return self;
}


@end