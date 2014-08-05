#import <Foundation/Foundation.h>


@interface Meaning : NSObject

@property (nonatomic, strong, readonly) NSString *text;

- (instancetype) initWithText:(NSString *)text;

@end