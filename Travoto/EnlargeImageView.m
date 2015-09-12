//
//  EnlargeImageView.m
//  Travoto
//
//  Created by Loanne Tran on 9/11/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "EnlargeImageView.h"

@implementation EnlargeImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.bigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 260, 250)];
        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(15, 277, 260, 105)];
        self.commentTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 402, 260, 30)];
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(265, 0, 25, 24)];
        
        [self.bigImgView.layer setCornerRadius:10];
        [self.bigImgView.layer setBorderWidth:1];
        [self.bigImgView.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.bigImgView setClipsToBounds:YES];
        [self.bigImgView setAlpha:0];
        
        [self.commentView setBackgroundColor:[UIColor clearColor]];
        [self.commentView setEditable:NO];
        [self.commentView setTextColor:[UIColor whiteColor]];
        [self.commentView setText:@"You have no comments at this time..."];
        
        [self.closeBtn setTitle:@"x" forState:UIControlStateNormal];
        [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closeBtn setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6]];
        [self.closeBtn.layer setCornerRadius:15];
        
        [self.commentTxt setBackgroundColor:[UIColor whiteColor]];
        [self.commentTxt setFont:[UIFont fontWithName:@"Avenir" size:12]];
        [self.commentTxt.layer setBorderWidth:0.5];
        [self.commentTxt.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.commentTxt.layer setCornerRadius:6];
        [self.commentTxt setPlaceholder:@"Enter comments here..."];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.commentTxt.leftView = paddingView;
        self.commentTxt.leftViewMode = UITextFieldViewModeAlways;

    }
    return self;
}


@end
