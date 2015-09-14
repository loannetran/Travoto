//
//  MapViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/11/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "MapAnnotation.h"
#import "CustomPinView.h"
#import "DBHandler.h"
#import "MapLocation.h"
#import "AppDelegate.h"


@interface MapViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    
        DBHandler *dbh;
        AppDelegate *appD;
}

@property (weak, nonatomic) IBOutlet UILabel *welcomeLbl;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *coder;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;
@property (nonatomic, assign) BOOL locationAvail;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *changePhotoLbl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
