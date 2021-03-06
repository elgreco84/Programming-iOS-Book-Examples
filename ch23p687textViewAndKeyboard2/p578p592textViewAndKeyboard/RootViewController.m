

#import "RootViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) IBOutlet UITextView *tv;
@end

@implementation RootViewController {
    CGFloat oldBottomConstraint;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

// -----

- (IBAction)doDone:(id)sender {
    [self.view endEditing:NO];
}

- (void) keyboardShow: (NSNotification*) n {
    // the heck with the constraints; the heck with resizing
    // we simply change the insets
    NSDictionary* d = [n userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tv.contentInset = UIEdgeInsetsMake(0,0,r.size.height,0);
    self.tv.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,r.size.height,0);
}

- (void) keyboardHide: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    NSNumber* curve = d[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.floatValue delay:0
                        options:curve.integerValue << 16 // sigh, have to convert here
                     animations:
     ^{
         [self.tv setContentOffset:CGPointZero];
     } completion:^(BOOL finished) {
         self.tv.contentInset = UIEdgeInsetsZero;
         self.tv.scrollIndicatorInsets = UIEdgeInsetsZero;
     }];
}

@end
