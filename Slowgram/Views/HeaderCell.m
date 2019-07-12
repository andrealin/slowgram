//
//  HeaderCell.m
//  Slowgram
//
//  Created by drealin on 7/11/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "HeaderCell.h"
#import "ProfileHeaderCell.h"
#import "Post.h"

@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPicture:)];
    [self.profilePhotoView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePhotoView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) didTapPicture:(UITapGestureRecognizer *)sender {

   
    [self.delegate didClickPicture:self.post.author];
}
- (void)updateWithPost:(Post *)post {
    // Format and set createdAtString
    NSDate *date = [post createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure date output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    self.usernameLabel.text = post.author[@"username"];
    self.dateLabel.text = [formatter stringFromDate:date];
    
    // make profile pic a circle
    CALayer *imageLayer = self.profilePhotoView.layer;
    [imageLayer setCornerRadius:self.profilePhotoView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    if ( post.author[@"profilePicture"] ) {
        self.profilePhotoView.file = post.author[@"profilePicture"];
        [self.profilePhotoView loadInBackground];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.post = post;
}
@end
