//
//  HomeViewController.m
//  Slowgram
//
//  Created by drealin on 7/8/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "SlowgramCell.h"
#import "DetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "HeaderCell.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate, HeaderCellDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSArray<Post *> *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@end

@implementation HomeViewController
InfiniteScrollActivityView *loadingMoreView;

NSString *HeaderViewIdentifier = @"TableViewHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 25;
    
    // refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
        
    [self fetchData];
    
}

- (void)fetchData {
    // construct query for posts in the home timeline
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data for home timeline posts asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) didPost { // because HomeViewController is a ComposeViewControllerDelegate
    [self fetchData];
}
// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data for the home timeline posts (top 20) asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            
            [self.tableView reloadData];
            
            // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)logoutClicked:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if ( error ) {
            // ignoring any logout errors
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SlowgramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlowgramCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.section];
    [cell updateWithPost:post];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"header"];
    
    Post *post = self.posts[section];
    [header updateWithPost:post];
    
    header.delegate = self;
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"detailsSegue" isEqualToString:segue.identifier]) {
        // segue from instagram photo to details
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.section];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    else if ([@"composeSegue" isEqualToString:segue.identifier]) {
        // segue to compose a post
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = navigationController.topViewController;
        composeViewController.delegate = self;
    }
    else if ([@"profileSegue" isEqualToString:segue.identifier]) {
        // segue to view a user's profile page
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
        
    }
}

-(void)loadMoreData{
    
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    
    // load twenty more posts past the last post loaded
    Post *post = self.posts[self.posts.count-1];
    NSDate *dateOfLastPost = post.createdAt;
    [postQuery whereKey:@"createdAt" lessThan:dateOfLastPost];
    postQuery.limit = 20;
    
    // fetch data asynchronously for 20 more posts to add to the home timeline
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if ([posts count] != 0) { // while there are still more posts
            // do something with the data fetched
            self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            
            // Update flag
            self.isMoreDataLoading = false;
            
            [self.tableView reloadData];

            // Stop the loading indicator
            [loadingMoreView stopAnimating];
            
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didClickPicture:(PFUser *)user {
    // show segue to the user's profile page
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


@end
