#import <Foundation/Foundation.h>

#import "Word.h"
#import "Meaning.h"
#import "Article.h"

@interface Card : NSObject

@property (nonatomic, strong, readonly) Word *word;

@property (nonatomic, strong, readonly) NSArray * /*of Meaning **/meanings;
@property (nonatomic) NSUInteger rightMeaningIndex;

- (instancetype)initWithArticle:(Article *)article falseMeaning:(Meaning *)meaning1 falseMeaning:
        (Meaning *)meaning2;

- (void)shuffleMeanings;

@end