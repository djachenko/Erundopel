#import <Foundation/Foundation.h>

#import "User.h"


@interface UserManager : NSObject

@property(nonatomic) User *currentUser;

- (NSMutableArray *)users;

- (BOOL)hasUser:(User *)user;
- (BOOL)hasUserWithName:(NSString *)name;

- (void)registerUser:(User *)user;
- (void)registerUserWithName:(NSString *)name password:(NSString *)password;

- (BOOL)loginWithUser:(User *)user;
- (BOOL)loginWithName:(NSString *)name password:(NSString *)password;

- (void)logout;

- (void)synchronize;

@end