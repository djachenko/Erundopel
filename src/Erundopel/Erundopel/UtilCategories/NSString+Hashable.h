#import <Foundation/Foundation.h>

static NSString *const salt = @"ErundopellUserSalt";

@interface NSString (Hashable)

-(NSString *)hashStringWithSalt:(NSString *)salt;

@end