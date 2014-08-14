#import "SettingsVC.h"

@interface SettingsVC ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.contentSize = self.contentView.frame.size;

    NSLog(@"content %f", self.scrollView.contentSize.height);
}

@end
