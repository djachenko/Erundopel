#import "CardAnswerVC.h"

@interface CardAnswerVC()

@property (nonatomic, strong) IBOutlet UILabel *word;
@property (nonatomic, strong) IBOutlet UILabel *answer;

@end

@implementation CardAnswerVC

- (void)setCard:(Card *)card
{
    _card = card;

    [self updateContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate
                    action:@selector(answerAccepted)];
    [self.view addGestureRecognizer:tapHandler];

    [self updateContent];
}

- (void)updateContent
{
    self.word.text = self.card.word.text;

    self.answer.text = ((Meaning *)self.card.meanings[self.card.rightMeaningIndex]).text;
}

- (IBAction)back:(UIButton *)sender
{
    [self.delegate finishGame];
}

@end
