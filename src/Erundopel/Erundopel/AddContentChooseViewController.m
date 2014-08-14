#import "AddContentChooseViewController.h"
#import "Word.h"
#import "Meaning.h"
#import "Article.h"
#import "Database.h"
#import "ParseManager.h"

@interface AddContentChooseViewController ()<UITextFieldDelegate>

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
    Database *db = [Database sharedInstance];
    
    NSLog(@"%d", self.selector.selectedSegmentIndex);
    
    switch (self.selector.selectedSegmentIndex) {
        case contentTypeWord: {
            NSString *wordString = [self.wordField.text lowercaseString];
            NSString *meaningString = [self.meaningField.text lowercaseString];

            Word *word = [[Word alloc] initWithText:wordString];
            Meaning *meaning = [[Meaning alloc] initWithText:meaningString];

            Article *article = [[Article alloc] initWithWord:word meaning:meaning];


            if ([db hasWordWithValue:article.word.text]) {
                [self showAlertWithTitle:@"Уже есть"
                    text:@"Такое слово уже есть в базе. Придумайте что-нибудь новое!"];
            } else if ([db hasMeaningWithValue:article.meaning.text]) {
                [self showAlertWithTitle:@"Уже есть"
                    text:@"Слово с таким значением уже есть в базе. Придумайте что-нибудь новое!"];
            } else {
                [[Database sharedInstance] addArticle:article];
                [[[ParseManager alloc] init] uploadAll];
                [self.navigationController popViewControllerAnimated:YES];
            }

            break;
        }
        case contentTypeMeaning: {

            NSString *meaningString = self.meaningView.text;

            Meaning *meaning = [[Meaning alloc] initWithText:[meaningString lowercaseString]];
            
            if ([db hasMeaningWithValue:meaning.text]) {
                [self showAlertWithTitle:@"Уже есть"
                    text:@"Такое значение уже есть в базе. Придумайте что-нибудь новое!"];
            } else {
                [[Database sharedInstance] addMeaning:meaning];
                 [[[ParseManager alloc] init] uploadAll];
                [self.navigationController popViewControllerAnimated:YES];
            }

            break;
        }
        default:
            break;
    }
}

- (void)showAlertWithTitle:(NSString *)title
    text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]
        initWithTitle:title
        message:text
        delegate:self
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil
    ];

    [alert show];
}

- (IBAction)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return NO;
}


@end
