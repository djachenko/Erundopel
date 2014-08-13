#import "RecordsVC.h"
#import "User.h"

@interface RecordsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *users;

@end

@implementation RecordsVC

- (instancetype)initWithUsers:(NSArray *)users
{
    self = [self init];

    if (self) {
        _users = [users  sortedArrayUsingComparator: ^(User *a, User *b) {
            double aRatio = (double)a.guessed / a.total;
            double bRatio = (double)b.guessed / b.total;

            if (aRatio > bRatio) {
                return NSOrderedDescending;
            }
            else if (aRatio < bRatio) {
                return NSOrderedAscending;
            }
            else {
                return NSOrderedSame;
            }
        }];
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"

    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];

    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:REUSABLE_CELL_ID];
    }

    User *user = self.users[indexPath.row];
    NSString *userName = user.name;

    NSLog(@"%@ %d\n", userName, indexPath.row);

    tableViewCell.textLabel.text = userName;
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%d / %d", user.guessed,
                    user.total];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)goBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
