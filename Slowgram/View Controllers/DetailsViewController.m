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
#import "DetailsHeaderCell.h"

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource, CommentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Comment *> *comments;
@property (strong, nonatomic) DetailsHeaderCell *header;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 10;
    
    [self fetchData];
}

- (void)fetchData {
    // query for comments on this post
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
}

- (void)didComment {
    [self fetchData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"commentSegue" isEqualToString:segue.identifier]) {
        // segue to open up compose view for a comment
        UINavigationController *navigationController = [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        commentViewController.post = self.post;
        commentViewController.delegate = self;

    }
}
- (IBAction)likeClicked:(id)sender {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"likes"];
    PFQuery *query = relation.query;
    [query whereKey:@"objectId" equalTo:self.post.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if (posts.count > 0) { // user has already liked this post
                [relation removeObject:self.post];
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self.post incrementKey:@"likeCount" byAmount:@(-1)];
                    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.header.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
                    }];
                }];
                
            }
            else { // user has yet to like this post
                [relation addObject:self.post];
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self.post incrementKey:@"likeCount" byAmount:@(1)];
                    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.header.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
                    }];
                }];

            }
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = comment.caption;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DetailsHeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"header"];
    self.header = header;
    
    self.header.photoView.file = self.post[@"image"];
    [self.header.photoView loadInBackground];
    self.header.captionLabel.text = self.post.caption;
    
    // Format and set createdAtString
    NSDate *date = [self.post createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    self.header.timestampLabel.text = [formatter stringFromDate:date];
    //    self.createdAtString = date.shortTimeAgoSinceNow;
    
    [self.header.likesCountButton setTitle:[self.post.likeCount stringValue] forState:UIControlStateNormal];
    header.backgroundColor = [UIColor whiteColor];
    
    return self.header;
}

@end
