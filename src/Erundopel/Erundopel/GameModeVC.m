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

@end

@implementation GameModeVC

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
