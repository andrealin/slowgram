//
//  ProfileHeaderCell.h
//  Slowgram
//
//  Created by drealin on 7/11/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderCell : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;

@end

NS_ASSUME_NONNULL_END
