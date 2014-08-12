//
//  GameModeVC.m
//  Erundopel
//
//  Created by Admin on 11/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "GameModeVC.h"
#import "CardGenerator.h"
#import "GameVC.h"

@interface GameModeVC ()

@property (nonatomic, strong) IBOutlet UIButton *buttonClassic;
@property (nonatomic, strong) IBOutlet UIButton *buttonRandom;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation GameModeVC

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
    GameVC *gameVC = [[GameVC alloc] init];
    [gameVC setGameMode:mode];
    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
