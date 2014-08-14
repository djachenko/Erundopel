#import "GameVC.h"
#import "CardQuestionVC.h"
#import "CardAnswerVC.h"
#import "UserManager.h"


@interface GameVC ()<CardQuestionVCDelegate, CardAnswerVCDelegate>

@property (nonatomic, strong) Card *currentCard;
@property (nonatomic) NSInteger count;

@property UserManager *userManager;

@property CardAnswerVC *answerVC;
@property CardQuestionVC *questionVC;

@property NSArray *animations;

@property (nonatomic, strong) CardGenerator *cardGenerator;

@end

@implementation GameVC

- (id)initWithUserManager:(UserManager *)userManager
{
    self = [self init];

    if (self) {
        _cardGenerator = [[CardGenerator alloc] initWithMode:CardGeneratorModeFixed];
        _count = 0;
        _userManager = userManager;

        _answerVC = [[CardAnswerVC alloc] init];
        _questionVC = [[CardQuestionVC alloc] init];

        _animations = @[@(UIViewAnimationOptionTransitionFlipFromLeft),
                @(UIViewAnimationOptionTransitionFlipFromRight),
                @(UIViewAnimationOptionTransitionCurlUp),
                @(UIViewAnimationOptionTransitionCurlDown)];
    }

    return self;
}

- (void)setGameMode:(CardGeneratorMode)mode
{
    self.cardGenerator = [[CardGenerator alloc] initWithMode:mode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.questionVC.delegate = self;
    self.answerVC.delegate = self;

    [self showCard:self.questionVC];
    [self showCard:self.answerVC];

    [self showNextQuestionCard];
}

- (void)showNextQuestionCard
{
    self.currentCard = self.cardGenerator.nextCard;
    [self.currentCard shuffleMeanings];

    self.questionVC.card = self.currentCard;
    self.answerVC.card = self.currentCard;

    /*self.answerVC.view.hidden = YES;
    self.questionVC.view.hidden = NO;*/

    UIViewAnimationOptions animation = (UIViewAnimationOptions) [(NSNumber *)self.animations[arc4random_uniform([self
                .animations count])] unsignedIntegerValue];

    [UIView transitionWithView:self.view
            duration:0.75
            options:animation
            animations:^{
                self.answerVC.view.hidden = YES;
                self.questionVC.view.hidden = NO;
            }
            completion:nil];
}

- (void)chosenCorrectOption:(BOOL)state
{
    [self.userManager.currentUser guessedRight:state];
    [self.userManager synchronize];

    [UIView transitionWithView:self.view
            duration:0.75
            options:arc4random_uniform(2) == 0 ? UIViewAnimationOptionTransitionFlipFromTop :
                    UIViewAnimationOptionTransitionFlipFromBottom
            animations:^{
                self.answerVC.view.hidden = NO;
                self.questionVC.view.hidden = YES;
            }
            completion:nil];
}

- (void)finishGame
{
    [self removeCard:self.answerVC];
    [self removeCard:self.questionVC];

    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)answerAccepted
{
    [self showNextQuestionCard];
}

- (void)showCard:(UIViewController *)cardVC
{
    cardVC.view.frame = self.view.frame;

    [self addChildViewController:cardVC];
    [self.view addSubview:cardVC.view];
}

- (void)removeCard:(UIViewController *)cardVC
{
    [cardVC.view removeFromSuperview];
    [cardVC removeFromParentViewController];
}

@end
