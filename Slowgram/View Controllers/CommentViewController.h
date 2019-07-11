//
//  CommentViewController.h
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CommentViewControllerDelegate

- (void)didComment;

@end

@interface CommentViewController : UIViewController
@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) id<CommentViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
