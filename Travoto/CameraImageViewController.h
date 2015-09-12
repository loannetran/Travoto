//
//  CameraImageViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/12/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import "LocationTableViewController.h"

@interface CameraImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLGeocoder *coder;

- (IBAction)useCamera:(id)sender;
@end
