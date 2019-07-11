//
//  ProfileViewController.h
//  Slowgram
//
//  Created by drealin on 7/10/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
