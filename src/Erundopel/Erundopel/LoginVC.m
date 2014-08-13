#import "LoginVC.h"
#import "UserManager.h"
#import "UIView+Shakeable.h"

@interface LoginVC ()<UITextFieldDelegate>

@property(nonatomic, strong) UserManager *userManager;

@property IBOutlet UISegmentedControl *control;

@property IBOutlet UITextField *loginField;
@property IBOutlet UITextField *passwordField;


typedef NS_ENUM(NSInteger, ActionType)
{
    actionTypeLogin = 0,
    actionTypeRegister = 1
};

@property ActionType currentMode;

@end

@implementation LoginVC

- (instancetype)initWithUserManager:(UserManager *)userManager
{
    self = [self init];

    if (self) {
        _userManager = userManager;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.passwordField.secureTextEntry = YES;

    switch (self.control.selectedSegmentIndex) {
        case 0:
            self.currentMode = actionTypeLogin;
            break;
        case 1:
            self.currentMode = actionTypeRegister;
            break;
        default:
            break;
    }
}

- (IBAction)login:(UIButton *)sender
{
    NSString *username = self.loginField.text;
    NSString *password = self.passwordField.text;

    if ([username isEqualToString:@""]) {
        [self.loginField shake];

        return;
    }

    switch (self.currentMode) {
        case actionTypeLogin:
            if ([self.userManager hasUserWithName:username]) {
                if ([self.userManager loginWithName:username password:password]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self.passwordField shake];
                }
            }
            else {
                [self.loginField shake];
            }

            break;
        case actionTypeRegister:
            if (![self.userManager hasUserWithName:username]) {
                if (![password isEqualToString:@""]) {
                    [self.userManager registerUserWithName:username password:password];

                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self.passwordField shake];
                }
            }
            else {
                [self.loginField shake];
            }

            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return NO;
}

- (IBAction)action:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.currentMode = actionTypeLogin;
            break;
        case 1:
            self.currentMode = actionTypeRegister;
            break;
        default:
            break;
    }
}

- (IBAction)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
