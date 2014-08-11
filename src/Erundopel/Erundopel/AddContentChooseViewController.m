#import "AddContentChooseViewController.h"
#import "Word.h"
#import "Meaning.h"
#import "Article.h"

@interface AddContentChooseViewController ()

@property IBOutlet UISegmentedControl *selector;

@property IBOutlet UIView *wordView;
@property IBOutlet UITextField *meaningView;

@property IBOutlet UITextField *wordField;
@property IBOutlet UITextField *meaningField;

typedef NS_ENUM(NSInteger, ContentType)
{
    ContentTypeWord = 0,
    ContentTypeMeaning = 1
};

@end

@implementation AddContentChooseViewController

- (IBAction)action:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case ContentTypeWord: {
            [self.wordView setHidden:NO];
            [self.meaningView setHidden:YES];

            break;
        }
        case ContentTypeMeaning: {
            [self.wordView setHidden:YES];
            [self.meaningView setHidden:NO];

            break;
        }
        default:
            break;
    }
}

- (IBAction)save:(UIButton *)sender
{
    switch (self.selector.selectedSegmentIndex) {
        case ContentTypeWord: {
            NSString *wordString = self.wordField.text;
            NSString *meaningString = self.meaningField.text;

            Word *word = [[Word alloc] initWithText:wordString];
            Meaning *meaning = [[Meaning alloc] initWithText:meaningString];

            Article *article = [[Article alloc] initWithWord:word meaning:meaning];

            //save article

            break;
        }
        case ContentTypeMeaning: {

            NSString *meaningString = self.meaningView.text;

            Meaning *meaning = [[Meaning alloc] initWithText:meaningString];

            //save meaning

            break;
        }
        default:
            break;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
