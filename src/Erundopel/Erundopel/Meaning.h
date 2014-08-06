#import <Foundation/Foundation.h>


@interface Meaning : NSObject <NSCopying>

@property (nonatomic, strong, readonly) NSString *text;

- (instancetype) initWithText:(NSString *)text;

@end