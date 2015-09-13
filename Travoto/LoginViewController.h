//
//  LoginViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/13/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface LoginViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UILabel *imgLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)doneSetUp:(id)sender;

- (IBAction)skipSetUp:(id)sender;

@end
