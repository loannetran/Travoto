//
//  LoginViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/13/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "MapViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.profileImgView.layer setCornerRadius:60];
    [self.profileImgView setClipsToBounds:YES];
    [self.doneBtn.layer setCornerRadius:10];
    [self.skipBtn.layer setCornerRadius:10];
    
    UITapGestureRecognizer *lblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    [self.imgLbl addGestureRecognizer:lblGesture];

    UITapGestureRecognizer *photoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    [self.profileImgView addGestureRecognizer:photoGesture];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:05 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0.0, self.nameTxt.frame.origin.y-270) animated:YES];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView animateWithDuration:05 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0.0, self.nameTxt.frame.origin.y-350) animated:YES];
    }];
    
    [self.nameTxt resignFirstResponder];
    
    return YES;
}

- (void)changePhoto{
    
    UIImagePickerController *imgControl = [[UIImagePickerController alloc] init];
    imgControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgControl.delegate = self;
    
    [self presentViewController:imgControl animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.profileImgView.image = info[UIImagePickerControllerOriginalImage];
    [self.imgLbl setHidden:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneSetUp:(id)sender {
    
    NSData *image1 = UIImagePNGRepresentation(self.profileImgView.image);
    NSData *image2 = UIImagePNGRepresentation([UIImage imageNamed:@"defaultPerson.png"]);
    
    if ([image1 isEqual:image2] || [self.nameTxt.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile Set Up" message:@"Tap Skip if you would like to finish setting up another time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UIImagePNGRepresentation(self.profileImgView.image) forKey:@"userImage"];
        [defaults setObject:self.nameTxt.text forKey:@"name"];
        [defaults setObject:@"done" forKey:@"login"];
        [defaults synchronize];
        
        [self performSegueWithIdentifier:@"profile" sender:self];
    
    }

}

- (IBAction)skipSetUp:(id)sender {
    
        [self performSegueWithIdentifier:@"profile" sender:self];
}


// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// 
// }


@end
