//
//  ProfileViewController.m
//  Slowgram
//
//  Created by drealin on 7/10/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "CollectionCell.h"
#import "ProfileHeaderCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<Post *> *posts;
@property (weak, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) ProfileHeaderCell *header;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self fetchPosts];
}

- (void) fetchPosts {
    // construct query for all posts by this user
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    
    if ( self.user ) {
        [postQuery whereKey:@"author" equalTo:self.user];
    }
    else {
        [postQuery whereKey:@"author" equalTo:PFUser.currentUser];
    }
    
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            
            [self.collectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell"
                                                                     forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    cell.photoView.file = post[@"image"];
    [cell.photoView loadInBackground];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ProfileHeaderCell *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"profileHeader" forIndexPath:indexPath];
    
    // make profile pic a circle
    CALayer *imageLayer = header.profilePhotoView.layer;
    [imageLayer setCornerRadius:header.profilePhotoView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    if (self.user) {
        header.usernameLabel.text = self.user[@"username"];
        if ( self.user[@"profilePicture"] ) {
            header.profilePhotoView.file = self.user[@"profilePicture"];
            [header.profilePhotoView loadInBackground];
        }
    }
    else {
        header.usernameLabel.text = PFUser.currentUser[@"username"];
        
        UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPicture:)];
        [header.profilePhotoView addGestureRecognizer:profileTapGestureRecognizer];
        [header.profilePhotoView setUserInteractionEnabled:YES];
        
        PFUser *user = PFUser.currentUser;
        if ( user[@"profilePicture"] ) {
            header.profilePhotoView.file = user[@"profilePicture"];
            [header.profilePhotoView loadInBackground];
        }
    }
    
    
    self.header = header;
    
    return header;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
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
    self.header.profilePhotoView.image = self.selectedImage;
    
    
    PFUser *user = PFUser.currentUser;
    user[@"profilePicture"] = [Post getPFFileFromImage:[self resizeImage:self.selectedImage withSize:CGSizeMake(300.0, 300.0)]];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        // Dismiss UIImagePickerController to go back to your original view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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


@end
