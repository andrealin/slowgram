//
//  ComposeViewController.m
//  Slowgram
//
//  Created by drealin on 7/8/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UITextView *captionView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Tap image placeholder to add picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPicture:)];
    [self.photoView addGestureRecognizer:profileTapGestureRecognizer];
    [self.photoView setUserInteractionEnabled:YES];
}
- (void) didTapPicture:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.selectedImage = editedImage;
    self.photoView.image = self.selectedImage;

    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)shareClicked:(id)sender {
    
    [Post postUserImage:[self resizeImage:self.selectedImage withSize:CGSizeMake(800.0, 800.0)] withCaption:self.captionView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:true completion:^{
            [self.homeViewController fetchData];
        }];
    }];
}


@end
