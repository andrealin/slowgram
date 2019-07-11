//
//  CollectionCell.h
//  Slowgram
//
//  Created by drealin on 7/10/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photoView;

@end

NS_ASSUME_NONNULL_END
