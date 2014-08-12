#import "Card.h"
#import "GameFinisher.h"

@protocol CardAnswerVCDelegate<GameFinisher>

- (void)answerAccepted;

@end

@interface CardAnswerVC : UIViewController

@property (nonatomic, weak) id<CardAnswerVCDelegate> delegate;
@property (nonatomic, strong) Card *card;

@end
