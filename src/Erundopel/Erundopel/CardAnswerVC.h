#import "Card.h"
#import "GameFinisher.h"

@protocol CardAnswerVCDelegate<GameFinisher>

- (void)answerAccepted;

@end

@interface CardAnswerVC : UIViewController

@property (nonatomic, strong) id<CardAnswerVCDelegate> delegate;

- (instancetype)initWithCard:(Card *)card;

@end
