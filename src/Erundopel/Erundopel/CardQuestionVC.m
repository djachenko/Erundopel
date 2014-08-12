#import "CardQuestionVC.h"

@interface CardQuestionVC ()

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation CardQuestionVC

- (instancetype)init
{
    self = [super init];

    if (self) {
        _buttons = [NSMutableArray arrayWithCapacity:3];
    }

    return self;
}

- (void)setCard:(Card *)card
{
    _card = card;

    [self updateContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop){
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }];

    [self updateContent];
}

- (void)updateContent
{
    self.wordLabel.text = self.card.word.text;

    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop){
        [button setTitle:((Meaning *)self.card.meanings[idx]).text forState:UIControlStateNormal];
    }];
}

- (IBAction)meaningChosen:(UIButton *)sender
{
    NSUInteger index = [self.buttons indexOfObject:sender];

    [self.delegate chosenCorrectOption:index == self.card.rightMeaningIndex];
}

- (IBAction)back:(UIButton *)sender
{
    [self.delegate finishGame];
}

@end
