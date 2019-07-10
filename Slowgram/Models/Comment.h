//
//  Comment.h
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;

@end

NS_ASSUME_NONNULL_END
