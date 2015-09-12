//
//  CameraImageViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/12/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "CameraImageViewController.h"

@interface CameraImageViewController (){
    
    UIImage *currentImage;
    CLLocation *currentLocation;
}

@end

@implementation CameraImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc]init];
    self.coder = [[CLGeocoder alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"No Camera");
    }

}

-(void)viewDidAppear:(BOOL)animated{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"No Camera");
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    currentImage = info[UIImagePickerControllerOriginalImage];
    
    self.photoImgView.image = currentImage;
    
    currentLocation = self.manager.location;
    
    LocationTableViewController *lVc = (LocationTableViewController *)[[[self.tabBarController viewControllers] objectAtIndex:2] topViewController];
    lVc.cameraImage = currentImage;
    lVc.cameraLocation = currentLocation;
    [self.tabBarController setSelectedIndex:2];

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:self completion:nil];
}

- (IBAction)useCamera:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"No Camera");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//
//}



@end
