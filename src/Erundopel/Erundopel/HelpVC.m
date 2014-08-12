#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (IBAction)understood:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
