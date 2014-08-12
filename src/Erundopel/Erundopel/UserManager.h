#import <Foundation/Foundation.h>

#import "User.h"


@interface UserManager : NSObject

@property(nonatomic) User *currentUser;

- (NSMutableArray *)users;

//- (void)registerUser:(User *)user;

- (void)loginWithUser:(User *)user;

- (void)loginWithName:(NSString *)name;

- (void)logout;

- (void)synchronize;

@end