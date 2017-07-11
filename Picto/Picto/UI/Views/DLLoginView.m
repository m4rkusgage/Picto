//
//  DLLoginView.m
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLLoginView.h"

@interface DLLoginView ()
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation DLLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.loginButton.layer setCornerRadius:5.0];
    [self.loginButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.loginButton.layer setBorderWidth:3.0];
}

- (IBAction)loginButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:loginStatus:)]) {
        [self.delegate loginView:self loginStatus:DLLoginStatusOK];
    }
}
- (IBAction)skipButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:loginStatus:)]) {
        [self.delegate loginView:self loginStatus:DLLoginStatusSkip];
    }
}
@end
