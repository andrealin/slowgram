//
//  SlowgramCell.h
//  Slowgram
//
//  Created by drealin on 7/8/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface SlowgramCell : UITableViewCell
- (void)updateWithPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
