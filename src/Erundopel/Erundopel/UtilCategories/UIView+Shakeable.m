#import "UIView+Shakeable.h"


@implementation UIView (Shakeable)

- (void)shake
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = self.frame;
                frame.origin.x -= 10;
                self.frame = frame;
            }
            completion:^(BOOL flag){
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            CGRect frame = self.frame;
                            frame.origin.x += 20;
                            self.frame = frame;
                        }
                        completion:^(BOOL flag2){
                            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                    animations:^{
                                        CGRect frame = self.frame;
                                        frame.origin.x -= 10;
                                        self.frame = frame;
                                    }
                                    completion:nil];
                        }];
            }];
}

@end