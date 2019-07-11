//
//  DetailsHeaderCell.h
//  Slowgram
//
//  Created by drealin on 7/11/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;

@end

NS_ASSUME_NONNULL_END
