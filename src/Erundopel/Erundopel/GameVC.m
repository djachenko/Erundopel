#import "GameVC.h"
#import "CardQuestionVC.h"
#import "CardAnswerVC.h"
#import "Database.h"
#import "UserManager.h"

@interface GameVC ()<CardQuestionVCDelegate, CardAnswerVCDelegate>

@property (nonatomic, strong) Card *currentCard;
@property (nonatomic) NSInteger count;

@property (nonatomic, strong) UIViewController *currentCardVC;

@property UserManager *userManager;

@end

@implementation GameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        _count = 0;
        _userManager = [[UserManager alloc] init];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self nextCard];
}

- (void)nextCard
{
    /*Word *word = [[Word alloc] initWithText:[NSString stringWithFormat:@"Word %d", self.count]];

    self.count++;

    Meaning *right = [[Meaning alloc] initWithText:@"right meaning"];

    Article *article = [[Article alloc] initWithWord:word meaning:right];

    Meaning *false1 = [[Meaning alloc] initWithText:@"false meaning 1"];
    Meaning *false2 = [[Meaning alloc] initWithText:@"false meaning 2"];

    self.currentCard = [[Card alloc] initWithArticle:article falseMeaning:false1
    falseMeaning:false2];*/

    Database *db = [[Database alloc] init];
    NSArray *cards = [db getAllFixedCards];

    self.currentCard = cards[0];

    CardQuestionVC *cardVC = [[CardQuestionVC alloc] initWithCard:self.currentCard];
    cardVC.delegate = self;

    [self addChildViewController:cardVC];
    [self.view addSubview:cardVC.view];
}

- (void)chosenCorrectOption:(BOOL)state
{
    self.userManager = [[UserManager alloc] init];
    [self.userManager.currentUser guessedRight:state];
    [self.userManager synchronize];

    CardAnswerVC *cardVC = [[CardAnswerVC alloc] initWithCard:self.currentCard];
    cardVC.delegate = self;

    [self addChildViewController:cardVC];
    [self.view addSubview:cardVC.view];

    [UIView transitionWithView:self.view
            duration:0.75
            options:arc4random_uniform(2) == 0 ? UIViewAnimationOptionTransitionFlipFromTop :
                    UIViewAnimationOptionTransitionFlipFromBottom
            animations:^{
                [self.currentCardVC removeFromParentViewController];

                [self addChildViewController:cardVC];
                [self.view addSubview:cardVC.view];
            }
            completion:nil];
}

- (void)finishGame
{
    [self.currentCardVC removeFromParentViewController];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)answerAccepted
{
    [self nextCard];
}

- (void)addChildViewController:(UIViewController *)childController
{
    childController.view.frame = self.view.frame;

    [super addChildViewController:childController];

    self.currentCardVC = childController;
}


@end
