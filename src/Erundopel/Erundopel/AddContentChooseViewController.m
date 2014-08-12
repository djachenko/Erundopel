#import "AddContentChooseViewController.h"
#import "Word.h"
#import "Meaning.h"
#import "Article.h"

@interface AddContentChooseViewController ()

@property(nonatomic, strong) IBOutlet UISegmentedControl *selector;

@property(nonatomic, strong) IBOutlet UIView *wordView;
@property(nonatomic, strong) IBOutlet UITextField *meaningView;

@property(nonatomic, strong) IBOutlet UITextField *wordField;
@property(nonatomic, strong) IBOutlet UITextField *meaningField;

typedef NS_ENUM(NSInteger, ContentType)
{
    contentTypeWord = 0,
    contentTypeMeaning = 1
};

@end

@implementation AddContentChooseViewController

- (IBAction)action:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case contentTypeWord: {
            self.wordView.hidden = NO;
            self.meaningView.hidden = YES;

            break;
        }
        case contentTypeMeaning: {
            self.wordView.hidden = YES;
            self.meaningView.hidden = NO;

            break;
        }
        default:
            break;
    }
}

- (IBAction)save:(UIButton *)sender
{
    switch (self.selector.selectedSegmentIndex) {
        case contentTypeWord: {
            NSString *wordString = self.wordField.text;
            NSString *meaningString = self.meaningField.text;

            Word *word = [[Word alloc] initWithText:wordString];
            Meaning *meaning = [[Meaning alloc] initWithText:meaningString];

            Article *article = [[Article alloc] initWithWord:word meaning:meaning];

            #warning
            //TODO: save article

            break;
        }
        case contentTypeMeaning: {

            NSString *meaningString = self.meaningView.text;

            Meaning *meaning = [[Meaning alloc] initWithText:meaningString];

            #warning
            //TODO: save meaning

            break;
        }
        default:
            break;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
