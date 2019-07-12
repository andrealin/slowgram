//
//  Comment.m
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "Comment.h"

@interface Comment() <PFSubclassing>
@end

@implementation Comment

@dynamic commentID;
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

@end
