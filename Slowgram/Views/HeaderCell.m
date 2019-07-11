//
//  HeaderCell.m
//  Slowgram
//
//  Created by drealin on 7/11/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "HeaderCell.h"
#import "ProfileHeaderCell.h"

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

@end
