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
    
    // Do any additional setup after loading the view.
    // construct query
    PFQuery *postQuery = [Comment query];
    [postQuery orderByDescending:@"createdAt"];
//    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"postID" equalTo:self.post.objectId];
    postQuery.limit = 20;
    //    postQuery.limit = 4;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable comments, NSError * _Nullable error) {
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"commentSegue" isEqualToString:segue.identifier]) {
        UINavigationController *navigationController = [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        commentViewController.post = self.post;

    }
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
