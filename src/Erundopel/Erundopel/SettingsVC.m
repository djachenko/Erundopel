#import "SettingsVC.h"
#import "ParseManager.h"

static NSString *const synchronizationModeIdentifier = @"erundopelSynchronizationModeIdentifier";
static NSString *const complexityIdentifier = @"erundopelComplexityIdentifier";

@interface SettingsVC ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UISwitch *synchronizationModeSwitch;
@property (nonatomic, strong) IBOutlet UISlider *complexitySlider;

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.contentSize = self.contentView.frame.size;

    NSLog(@"content %f", self.scrollView.contentSize.height);

    BOOL automaticSynchronizationEnabled = [[NSUserDefaults standardUserDefaults]
            boolForKey:synchronizationModeIdentifier];
    float complexity = [[NSUserDefaults standardUserDefaults] floatForKey:complexityIdentifier];

    self.synchronizationModeSwitch.on = automaticSynchronizationEnabled;
    self.complexitySlider.value = complexity;
}

- (IBAction)synchronizationModeSwitched:(UISwitch *)sender
{
    BOOL automaticSynchronizationEnabled = self.synchronizationModeSwitch.on;

    [[NSUserDefaults standardUserDefaults] setBool:automaticSynchronizationEnabled
            forKey:synchronizationModeIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)synchronizeNOW:(UIButton *)sender
{
    [[[ParseManager alloc] init] downloadAll];
}

- (IBAction)setComplexity:(UISlider *)sender
{
    float value = self.complexitySlider.value;

    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:complexityIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
