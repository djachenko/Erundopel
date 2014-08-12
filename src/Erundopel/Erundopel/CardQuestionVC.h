#import <UIKit/UIKit.h>
#import "Card.h"
#import "GameFinisher.h"

@protocol CardQuestionVCDelegate<GameFinisher>

- (void)chosenCorrectOption:(BOOL)state;

@end

@interface CardQuestionVC : UIViewController

@property (nonatomic, weak) id<CardQuestionVCDelegate> delegate;
@property (nonatomic, strong) Card *card;
@end
