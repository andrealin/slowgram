//
//  CommentViewController.m
//  Slowgram
//
//  Created by drealin on 7/9/19.
//  Copyright © 2019 drealin. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)commentClicked:(id)sender {
    // comment
    NSString *caption = self.commentView.text;
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
