#import "UserManager.h"
#import "NSString+Hashable.h"

static NSString *UserIdentifier = @"ErundopelUserIdentifier";
static NSString *arrayKey = @"olololololoo";

@interface UserManager()

@property(nonatomic) NSMutableArray *users;

@end

@implementation UserManager

User *_user;
User *_anon;

- (User *)currentUser;
{
    if (!_user) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdentifier];

        if (!userData) {
           _user = self.anonymous;
        }
        else {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

            //[self loginWithUser:[NSKeyedUnarchiver unarchiveObjectWithData:userData]];
        }
    }

    return _user;
}

- (User *)anonymous
{
    if (!_anon) {
        _anon = [[User alloc] initWithName:@"Anonymous" password:nil];
    }

    return _anon;
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

- (BOOL)hasUser:(User *)user
{
    return [self.users indexOfObject:user] != NSNotFound;
}

- (BOOL)hasUserWithName:(NSString *)name
{
    for (User *user in self.users) {
        if ([user.name isEqualToString:name]) {
            return YES;
        }
    }

    return NO;
}

- (void)registerUser:(User *)user
{
    [self.users addObject:user];
    [self loginWithUser:user];

    [self synchronize];
}

- (void)registerUserWithName:(NSString *)name password:(NSString *)password
{
    User *user = [[User alloc] initWithName:name password:password];

    [self registerUser:user];
}


- (BOOL)loginWithUser:(User *)user
{
    if (user == self.anonymous || [self.users indexOfObject:user] != NSNotFound) {
        _user = user;

        [self synchronize];

        NSLog(@"prenot %@ %@", _user.name, self.delegate);

        [self.delegate notifyPlayerChanged:user.name];

        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)loginWithName:(NSString *)name password:(NSString *)password {
    password = [password hashStringWithSalt:salt];

    for (User *user in self.users) {
        if ([user.name isEqualToString:name] && [user.password isEqualToString:password]) {
            return [self loginWithUser:user];
        }
    }

    return NO;
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self loginWithUser:self.anonymous];

    NSLog(@"outed");
}

- (void)synchronize
{
    if (self.currentUser != self.anonymous) {
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:UserIdentifier];
    }

    NSData *usersData = [NSKeyedArchiver archivedDataWithRootObject:self.users];

    [[NSUserDefaults standardUserDefaults] setObject:usersData forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end