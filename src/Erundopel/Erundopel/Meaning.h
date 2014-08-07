#import <Foundation/Foundation.h>
#import "ParseObject.h"


@interface Meaning : NSObject <NSCopying, ParseObject>

@property (nonatomic, strong, readonly) NSString *text;

- (instancetype) initWithText:(NSString *)text;

@end