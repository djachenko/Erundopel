//
//  MainMenuVC.m
//  Erundopel
//
//  Created by Admin on 01/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "MainMenuVC.h"

@interface MainMenuVC ()

@property (nonatomic, weak) IBOutlet UIButton *buttonNewGame;
@property (nonatomic, weak) IBOutlet UIButton *buttonAddContent;
@property (nonatomic, weak) IBOutlet UIButton *buttonSettings;
@property (nonatomic, weak) IBOutlet UIButton *buttonHowToPlay;
@property (nonatomic, weak) IBOutlet UIButton *buttonRecords;

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
    NSLog(@"New Game pressed");
}

- (IBAction)buttonAddContentTap:(UIButton *)sender {
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
