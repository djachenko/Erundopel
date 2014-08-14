#import "GameModeVC.h"
#import "CardGenerator.h"
#import "GameVC.h"

@interface GameModeVC ()

@property (nonatomic, strong) IBOutlet UIButton *buttonClassic;
@property (nonatomic, strong) IBOutlet UIButton *buttonRandom;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UserManager *manager;

@end

@implementation GameModeVC

-(instancetype)initWithUserManager:(UserManager *)userManager
{
    self = [self init];

    if (self) {
        _buttons = [[NSMutableArray alloc] init];
        _manager = userManager;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buttons addObject:self.buttonClassic];
    [self.buttons addObject:self.buttonRandom];
    
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
}

- (IBAction)classicModeTap:(id)sender
{
    [self startGameWithMode:CardGeneratorModeFixed];
}

- (IBAction)randomModeTap:(id)sender
{
    [self startGameWithMode:CardGeneratorModeRandom];
}

- (void)startGameWithMode:(CardGeneratorMode)mode
{
    GameVC *gameVC = [[GameVC alloc] initWithUserManager:self.manager];
    [gameVC setGameMode:mode];
    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
