#import "HelpVC.h"

@interface HelpVC ()

@property IBOutlet UITextView *helpView;

@end

@implementation HelpVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.helpView.text = NSLocalizedString(@"helpString", @"Help string");
}

- (IBAction)understood:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
