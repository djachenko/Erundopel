//
//  MainMenuVC.m
//  Erundopel
//
//  Created by Admin on 01/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "MainMenuVC.h"

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