#import "UserManager.h"

static NSString *UserIdentifier = @"ErundopelUserIdentifier";
static NSString *arrayKey = @"olololololoo";

@interface UserManager()

@property(nonatomic) NSMutableArray *users;

@end

@implementation UserManager

User *_user;

- (User *)currentUser;
{
    if (!_user) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdentifier];

        if (!userData) {
            [self loginWithUser:[[User alloc] initWithName:@"Anonymous"]];
        }
        else {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
    }

    return _user;
}

- (NSMutableArray *)users
{
    if (!_users) {
        NSData *usersData = [[NSUserDefaults standardUserDefaults] objectForKey:arrayKey];

        if (!usersData) {
            _users = [NSMutableArray array];
        }
        else {
            _users = [[NSKeyedUnarchiver unarchiveObjectWithData:usersData] mutableCopy];
        }
    }

    return _users;
}

- (void)registerUser:(User *)user
{
    [self.users addObject:user];

    [self synchronize];
}

- (void)loginWithUser:(User *)user
{
    _user = user;

    [self synchronize];
}

- (void)loginWithName:(NSString *)name
{
    for (User *user in self.users) {
        if ([user.name isEqualToString:name]) {
            [self loginWithUser:user];
        }
    }
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    _user = nil;
}

- (void)synchronize
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
    NSData *usersData = [NSKeyedArchiver archivedDataWithRootObject:self.users];

    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:UserIdentifier];
    [[NSUserDefaults standardUserDefaults] setObject:usersData forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"Written ");
}


@end