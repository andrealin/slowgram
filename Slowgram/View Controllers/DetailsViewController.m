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

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
