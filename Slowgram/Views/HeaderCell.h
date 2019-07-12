//
//  HeaderCell.h
//  Slowgram
//
//  Created by drealin on 7/11/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HeaderCellDelegate
- (void)didClickPicture:(PFUser *)user;

@end

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) Post *post;
@property (nonatomic, weak) id<HeaderCellDelegate> delegate;
- (void)updateWithPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
