#import <Foundation/Foundation.h>


@interface User : NSObject<NSCoding>

@property NSString *name;
@property(nonatomic) NSString *password;

@property NSInteger guessed;
@property(nonatomic) NSInteger total;

- (instancetype)initWithName:(NSString *)name password:(NSString *)password;
// CR: method name should start with a verb.
- (void)guessedRight:(BOOL)state;

@end