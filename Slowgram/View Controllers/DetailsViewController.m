//
//  DetailsViewController.m
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "DetailsViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "CommentViewController.h"
#import "Comment.h"

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Comment *> *comments;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSLog(@"details view loading");
    
    // Do any additional setup after loading the view.
    self.photoView.file = self.post[@"image"];
    [self.photoView loadInBackground];
    self.captionLabel.text = self.post.caption;
    
    // Format and set createdAtString
    NSDate *date = [self.post createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    self.timestampLabel.text = [formatter stringFromDate:date];
//    self.createdAtString = date.shortTimeAgoSinceNow;
 
    
    PFRelation *relation = [self.post relationForKey:@"commentRelations"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable comments, NSError * _Nullable error) {
        if (comments) {
            // do something with the data fetched
            self.comments = comments;
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.tableView reloadData];
    [self.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"commentSegue" isEqualToString:segue.identifier]) {
        UINavigationController *navigationController = [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        commentViewController.post = self.post;

    }
}
- (IBAction)likeClicked:(id)sender {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"likes"];
    PFQuery *query = relation.query;
    [query whereKey:@"objectId" equalTo:self.post.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            if (posts.count > 0) { // already liked, now unliking
                [relation removeObject:self.post];
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self.post incrementKey:@"likeCount" byAmount:@(-1)];
                    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
                    }];
                }];
                
            }
            else { // liking
                [relation addObject:self.post];
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self.post incrementKey:@"likeCount" byAmount:@(1)];
                    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
                    }];
                }];

            }
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = comment.caption;
    return cell;
}


@end
