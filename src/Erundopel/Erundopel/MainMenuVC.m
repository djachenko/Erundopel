#import "MainMenuVC.h"
#import "Database.h"
#import "CardQuestionVC.h"
#import "GameVC.h"
#import "GameModeVC.h"
#import "ParseManager.h"

@interface MainMenuVC ()

@property (nonatomic, strong) IBOutlet UIButton *buttonNewGame;
@property (nonatomic, strong) IBOutlet UIButton *buttonAddContent;
@property (nonatomic, strong) IBOutlet UIButton *buttonSettings;
@property (nonatomic, strong) IBOutlet UIButton *buttonHowToPlay;
@property (nonatomic, strong) IBOutlet UIButton *buttonRecords;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation MainMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buttons addObject:self.buttonNewGame];
    [self.buttons addObject:self.buttonAddContent];
    [self.buttons addObject:self.buttonSettings];
    [self.buttons addObject:self.buttonHowToPlay];
    [self.buttons addObject:self.buttonRecords];
    
    CGFloat coefficient = 2.3;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        for (UIButton *button in self.buttons) {
            button.titleLabel.font  = [UIFont fontWithName:@"Georgia" size:button.titleLabel.font.pointSize * coefficient];
        }
        self.headerLabel.font  = [UIFont fontWithName:@"Georgia" size:self.headerLabel.font.pointSize * coefficient];
    }
    
}

- (IBAction)buttonNewGameTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[GameModeVC alloc] init] animated:YES];
}

- (IBAction)buttonAddContentTap:(UIButton *)sender {
    [[[ParseManager alloc] init] downloadAll];
    NSLog(@"Add Content pressed");
}

- (IBAction)buttonSettingsTap:(UIButton *)sender {
    NSLog(@"Settings pressed");
}

- (IBAction)buttonHowToPlay:(UIButton *)sender {
    NSLog(@"How To Play pressed");
}

- (IBAction)buttonRecords:(UIButton *)sender {
    NSLog(@"Records pressed");
}

@end
