#import "MainMenuVC.h"
#import "GameVC.h"
#import "GameModeVC.h"
#import "ParseManager.h"
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

- (IBAction)buttonNewGameTap:(UIButton *)sender {
    [self.navigationController pushViewController:[[GameModeVC alloc] init] animated:YES];
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

    [[[ParseManager alloc] init] downloadAll];
}

@end
