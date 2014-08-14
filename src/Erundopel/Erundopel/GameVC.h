#import <UIKit/UIKit.h>
#import "CardGenerator.h"

@class UserManager;

@interface GameVC : UIViewController

- (id)initWithUserManager:(UserManager *)userManager;
- (void)setGameMode:(CardGeneratorMode)mode;

@end
