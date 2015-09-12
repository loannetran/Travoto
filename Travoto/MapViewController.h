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

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *coder;
@property (nonatomic, strong) NSArray *places;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
