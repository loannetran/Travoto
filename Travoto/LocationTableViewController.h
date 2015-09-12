//
//  LocationTableViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import "AlbumViewController.h"
#import <MapKit/MKAnnotation.h>
#import "MapAnnotation.h"
#import "MapViewController.h"

@interface LocationTableViewController : UITableViewController <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *countries;
@property (nonatomic,strong) CLGeocoder *coder;
@property (nonatomic,strong) NSMutableArray *savedLocations;
@property (nonatomic,strong) UIImage *cameraImage;
@property (nonatomic,strong) CLLocation *cameraLocation;

- (IBAction)addPhotos:(id)sender;

@end
