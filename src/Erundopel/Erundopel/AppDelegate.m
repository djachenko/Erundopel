#import "AppDelegate.h"
#import "MainMenuVC.h"
#import "ParseCard.h"
#import "ParseWord.h"
#import "ParseMeaning.h"
#import "ParseLanguage.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UINavigationController *navigationController = [[UINavigationController alloc]
            initWithRootViewController:[[MainMenuVC alloc] init]];

    navigationController.navigationBar.hidden = YES;

    self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    
    // register Parse PFObject subclasses
    [ParseLanguage registerSubclass];
    [ParseMeaning registerSubclass];
    [ParseWord registerSubclass];
    [ParseCard registerSubclass];
    
    // authorize app to Parse.com
    [Parse setApplicationId:@"WmRYckJZWu9SaAEGu32YdDFHlBH2jjd0ziaWrYqR"
        clientKey:@"SiijCQNsyaxMyOL6K43DgrkJQ5v4jY8cFVpgMorx"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
