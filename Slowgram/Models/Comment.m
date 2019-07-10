//
//  Comment.m
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "Comment.h"
#import "Post.h"

@implementation Comment

@dynamic commentID;
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
//@dynamic post;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}


+ (void)postComment:(Post *)post withCaption:(NSString *)caption withCompletion:(PFBooleanResultBlock)completion {
    // help
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
//    newComment.post = post;
    newComment.caption = caption;
    
    [newComment saveInBackgroundWithBlock: completion];

//    [post postComment:newComment];
    
}
@end
