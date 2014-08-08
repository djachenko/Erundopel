#import "CardAnswerVC.h"

@interface CardAnswerVC()

@property (nonatomic, strong) IBOutlet UILabel *word;
@property (nonatomic, strong) IBOutlet UILabel *answer;

@property (nonatomic, strong) Card *origin;

@end

@implementation CardAnswerVC

- (instancetype)initWithCard:(Card *)card
{
    self = [self init];

    if (self) {
        _origin = card;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.word setText:self.origin.word.text];

    [self.answer setText:((Meaning *)self.origin.meanings[self.origin.rightMeaningIndex]).text];

    UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate
                    action:@selector(answerAccepted)];
    [self.view addGestureRecognizer:tapHandler];
}

- (IBAction)back:(UIButton *)sender
{
    [self.delegate finishGame];
}

@end
