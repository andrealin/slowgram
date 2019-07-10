//
//  Post.m
//  Slowgram
//
//  Created by drealin on 7/8/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "Post.h"
#import "Comment.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
//@dynamic comments;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

- (void) postComment: ( Comment *)comment withCompletion: (PFBooleanResultBlock _Nullable)completion {
    // help
//    [self.comments addObject:comment];
    
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
        
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData]; // used to be PFFile not PFFileObject
}

@end
