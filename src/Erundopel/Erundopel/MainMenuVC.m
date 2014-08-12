#import "MainMenuVC.h"
#import "GameVC.h"
#import "AddContentChooseViewController.h"
#import "HelpVC.h"
#import "LoginVC.h"

@interface MainMenuVC ()

@property (nonatomic, strong) IBOutlet UIButton *buttonNewGame;
@property (nonatomic, strong) IBOutlet UIButton *buttonAddContent;
@property (nonatomic, strong) IBOutlet UIButton *buttonSettings;
@property (nonatomic, strong) IBOutlet UIButton *buttonHowToPlay;
@property (nonatomic, strong) IBOutlet UIButton *buttonRecords;

@end

@implementation MainMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonNewGameTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[GameVC alloc] init] animated:YES];
}

- (IBAction)buttonAddContentTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[AddContentChooseViewController alloc] init] animated:YES];
}

- (IBAction)buttonSettingsTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[LoginVC alloc] init] animated:YES];
}

- (IBAction)buttonHowToPlay:(UIButton *)sender {
    [self presentViewController:[[HelpVC alloc] init] animated:YES completion:nil];
}

- (IBAction)buttonRecords:(UIButton *)sender {
    NSLog(@"Records pressed");
}

@end
