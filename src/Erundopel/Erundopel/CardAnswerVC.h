#import "Card.h"
#import "GameFinisher.h"

@protocol CardAnswerVCDelegate<GameFinisher>

- (void)answerAccepted;

@end

@interface CardAnswerVC : UIViewController

@property (nonatomic, strong) id<CardAnswerVCDelegate> cardDelegate;

- (instancetype)initWithCard:(Card *)card;

@end
