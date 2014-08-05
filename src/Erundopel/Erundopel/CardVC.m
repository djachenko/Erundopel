//
//  CardVC.m
//  Erundopel
//
//  Created by Admin on 03/08/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import "CardVC.h"

@interface CardVC ()

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *buttons;
@property (nonatomic, strong) Card *origin;

@end

@implementation CardVC

- (instancetype)initWithCard:(Card *)card
{
    self = [self init];

    if (self) {
        _origin = card;
        _buttons = [NSMutableArray arrayWithCapacity:3];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.wordLabel setText:self.origin.word.text];

    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop){
        [button setTitle:((Meaning *)self.origin.meanings[idx]).text forState:UIControlStateNormal];
    }];
}

- (IBAction)meaningChosen:(UIButton *)sender
{
    int index = -1;

    for (int i = 0; i < [self.buttons count]; i++) {
        if (sender == self.buttons[i]) {
            index = i;

            break;
        }
    }

    NSLog(@"Button %d pressed", index);
    //Send index somewhere outside
}

@end
