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
    [self.post postComment:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:true completion:^{
            [self.delegate didComment];
        }];
    }];
}

@end
