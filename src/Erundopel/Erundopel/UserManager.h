#import <Foundation/Foundation.h>

#import "User.h"

@protocol UserManagerDelegate<NSObject>

- (void)notifyPlayerChanged:(NSString *)name;

@end

@interface UserManager : NSObject

@property (nonatomic, weak) id<UserManagerDelegate> delegate;
@property (nonatomic, strong, readonly) User *currentUser;
@property (nonatomic, strong, readonly) User *anonymous;

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