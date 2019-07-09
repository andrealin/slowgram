//
//  SlowgramCell.m
//  Slowgram
//
//  Created by drealin on 7/8/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "SlowgramCell.h"
#import "Post.h" // do I need this again? it was imported in SlowgramCell.h already
#import "Parse/Parse.h"
#import "Parse/PFCollectionViewCell.h"
#import "Parse/PFImageView.h"

@interface SlowgramCell()
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;

@end

@implementation SlowgramCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithPost:(Post *)post {
    self.photoView.file = post[@"image"];
    [self.photoView loadInBackground];
    self.captionLabel.text = post.caption;
}

@end
