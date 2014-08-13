#import "LoginVC.h"
#import "UserManager.h"

@interface LoginVC ()<UITextFieldDelegate>

@property UserManager *userManager;

@property IBOutlet UISegmentedControl *control;

@property IBOutlet UITextField *loginField;
@property IBOutlet UITextField *passwordField;


typedef NS_ENUM(NSInteger, ActionType)
{
    ActionTypeLogin = 0,
    ActionTypeRegister = 1
};

@property ActionType currentMode;

@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        _userManager = [[UserManager alloc] init];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.passwordField.secureTextEntry = YES;

    switch (self.control.selectedSegmentIndex) {
        case 0:
            self.currentMode = ActionTypeLogin;
            break;
        case 1:
            self.currentMode = ActionTypeRegister;
            break;
        default:
            break;
    }
}

- (IBAction)login:(UIButton *)sender
{
    NSString *username = self.loginField.text;
    // CR: always check your project for warnings. some of them can be useful.
    NSString *password = self.passwordField.text;

    [self.userManager loginWithName:username];

    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return NO;
}

- (IBAction)action:(UISegmentedControl *)sender
{

}

- (IBAction)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
