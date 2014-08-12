#import <Foundation/Foundation.h>


@interface User : NSObject<NSCoding>

@property NSString *name;
@property NSInteger guessed;
@property(nonatomic) NSInteger total;

- (instancetype)initWithName:(NSString *)name;
- (void)guessedRight:(BOOL)state;

@end