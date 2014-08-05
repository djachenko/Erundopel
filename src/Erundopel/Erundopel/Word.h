#import <Foundation/Foundation.h>


@interface Word : NSObject

@property (nonatomic, strong, readonly) NSString *text;

- (instancetype) initWithText:(NSString *)text;

@end