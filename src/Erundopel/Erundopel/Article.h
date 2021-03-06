#import <Foundation/Foundation.h>

#import "Word.h"
#import "Meaning.h"


@interface Article : NSObject

@property (nonatomic, strong, readonly) Word *word;
@property (nonatomic, strong, readonly) Meaning *meaning;

- (instancetype) initWithWord:(Word *)word meaning:(Meaning *)meaning;

@end