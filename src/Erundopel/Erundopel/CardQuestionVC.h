#import <UIKit/UIKit.h>
#import "Card.h"
#import "GameFinisher.h"

@protocol CardQuestionVCDelegate<GameFinisher>

- (void)chosenCorrectOption:(BOOL)state;

@end

@interface CardQuestionVC : UIViewController

@property (nonatomic, strong) id<CardQuestionVCDelegate> delegate;

- (instancetype)initWithCard:(Card *)card;

@end
