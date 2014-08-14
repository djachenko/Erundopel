#import "MainMenuVC.h"
#import "GameModeVC.h"
#import "AddContentChooseVC.h"
#import "HelpVC.h"
#import "LoginVC.h"
#import "RecordsVC.h"
#import "SettingsVC.h"

static void *const context = (void *const) &context;

@interface MainMenuVC ()<UserManagerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *buttonNewGame;
@property (nonatomic, strong) IBOutlet UIButton *buttonAddContent;
@property (nonatomic, strong) IBOutlet UIButton *buttonSettings;
@property (nonatomic, strong) IBOutlet UIButton *buttonHowToPlay;
@property (nonatomic, strong) IBOutlet UIButton *buttonRecords;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UserManager *userManager;

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;
@end

@implementation MainMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _buttons = [[NSMutableArray alloc] init];
        _userManager = [[UserManager alloc] init];

        _userManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buttons removeAllObjects];
    
    [self.buttons addObject:self.buttonNewGame];
    [self.buttons addObject:self.buttonAddContent];
    [self.buttons addObject:self.buttonSettings];
    [self.buttons addObject:self.buttonHowToPlay];
    [self.buttons addObject:self.buttonRecords];
    [self.buttons addObject:self.loginButton];
    [self.buttons addObject:self.logoutButton];
    
    
    CGFloat coefficient = 2.3;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *fontFamily = @"Georgia";
        for (UIButton *button in self.buttons) {
            button.titleLabel.font  = [UIFont
                fontWithName:fontFamily
                size:button.titleLabel.font.pointSize * coefficient
            ];
        }
        self.headerLabel.font  = [UIFont
            fontWithName:fontFamily
            size:self.headerLabel.font.pointSize * coefficient
        ];
    }

    [self notifyPlayerChanged:nil];
}

- (IBAction)buttonNewGameTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[GameModeVC alloc] initWithUserManager:self.userManager]
            animated:YES];
}

- (IBAction)buttonAddContentTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[AddContentChooseVC alloc] init] animated:YES];
}

- (IBAction)buttonSettingsTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[SettingsVC alloc] init] animated:YES];
}

- (IBAction)buttonHowToPlay:(UIButton *)sender {
    [self presentViewController:[[HelpVC alloc] init] animated:YES completion:nil];
}

- (IBAction)buttonRecords:(UIButton *)sender {
    [self presentViewController:[[RecordsVC alloc] initWithUsers:self.userManager.users] animated:YES
            completion:nil];
}

- (IBAction)userButtonTap:(UIButton *)sender
{
    LoginVC *loginVC = [[LoginVC alloc] initWithUserManager:self.userManager];

    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)logoutButtonTap:(UIButton *)sender
{
    [self.userManager logout];
}

- (void)notifyPlayerChanged:(NSString *)name
{
    [self.loginButton setTitle:[NSString stringWithFormat:@"Вы %@", self.userManager.currentUser.name]
            forState:UIControlStateNormal];

    self.logoutButton.hidden = self.userManager.currentUser == self.userManager.anonymous;
}


@end
