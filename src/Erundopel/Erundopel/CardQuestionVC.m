#import "CardQuestionVC.h"

@interface CardQuestionVC ()

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *buttons;
@property (nonatomic, strong) Card *origin;

@end

@implementation CardQuestionVC

- (instancetype)initWithCard:(Card *)card
{
    self = [self init];

    if (self) {
        _buttons = [NSMutableArray arrayWithCapacity:3];
        _origin = card;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.wordLabel setText:self.origin.word.text];

    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;

        NSAttributedString *title = [[NSAttributedString alloc]
                initWithString:((Meaning *)self.origin.meanings[idx]).text
                attributes: @{NSParagraphStyleAttributeName: paragraphStyle}];

        [button setAttributedTitle:title
                forState:UIControlStateNormal];
    }];
}

- (IBAction)meaningChosen:(UIButton *)sender
{
    NSUInteger index = 4;

    for (NSUInteger i = 0; i < [self.buttons count]; i++) {
        if (sender == self.buttons[i]) {
            index = i;

            break;
        }
    }

    [self.delegate chosenCorrectOption:index == self.origin.rightMeaningIndex];
}

@end
