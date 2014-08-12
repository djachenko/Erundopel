#import <Foundation/Foundation.h>


@interface User : NSObject<NSCoding>

@property NSString *name;
@property NSInteger guessed;
@property(nonatomic) NSInteger total;

- (instancetype)initWithName:(NSString *)name;
// CR: method name should start with a verb.
- (void)guessedRight:(BOOL)state;

@end