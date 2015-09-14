//
//  MapViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/11/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //------------------------------------
    
    //setting up variables
    self.manager = [[CLLocationManager alloc] init];
    self.coder = [[CLGeocoder alloc]init];
    dbh = [[DBHandler alloc] init];
    
    self.manager.delegate = self;
    [self.userImg.layer setCornerRadius:60];
    [self.userImg setClipsToBounds:YES];
    
    //----------getting user defaults for image and name
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if ([def objectForKey:@"userImage"]) {
        
        NSData* imageData = [def objectForKey:@"userImage"];
        self.userImg.image = [UIImage imageWithData:imageData];
        [self.changePhotoLbl setHidden:YES];
    }
    
    if ([def objectForKey:@"name"]) {
        self.welcomeLbl.text = [NSString stringWithFormat:@"Welcome %@",[def objectForKey:@"name"]];
    }
    
    //------------------------------------

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.internetActive = appDelegate.internetActive;
    self.hostActive = appDelegate.hostActive;
    
    //----setting up gestures for profile image
    UITapGestureRecognizer *lblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    
    [self.changePhotoLbl addGestureRecognizer:lblGesture];
    UITapGestureRecognizer *photoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    [self.userImg addGestureRecognizer:photoGesture];
    
    //-------------------------------------
    
    //if internet is active, ask for user's location permission
    
    if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                   to:self.manager
                                                 from:self
                                             forEvent:nil];
            [self setUpMapView];
    } else {
        self.mapView.showsUserLocation = YES;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.manager.location.coordinate, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        [self.manager startUpdatingLocation];
    }
    
    if (self.internetActive) {

    }

}

-(void)setUpMapView{
    

        NSArray *fetchedObjects = [dbh fetchAllItemsFromEntityNamed:@"MapLocation"];
        if (fetchedObjects == nil) {
            NSLog(@"Error");
        } else {
            for (MapLocation *loc in fetchedObjects) {
                
                if ([loc.latitude doubleValue] == 0 && [loc.longitude doubleValue] == 0) {
                    
                    if (self.internetActive) {
                        
                        NSString *place = [NSString stringWithFormat:@"%@ %@",loc.countryName, loc.cityName];
                        
                        [self.coder geocodeAddressString:place
                                       completionHandler:^(NSArray *placemarks, NSError *error) {
                                           if(!error){
                                               
                                               CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                               NSArray *fetchedObjects = [dbh updateEntity:@"MapLocation" whereAttribute:@"cityName" isEqualTo:loc.cityName];
                                               
                                               MapLocation *locationGrabbed = [fetchedObjects objectAtIndex:0];
                                               locationGrabbed.latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
                                               locationGrabbed.longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
                                               
                                               [dbh.cds saveContext];
                                               
                                           } else {
                                               
                                               NSLog(@"%@",[error description]);
                                               
                                               
                                           }
                                       }];
                        
                    }
                    
                }else{
                    //            NSLog(@"%@",loc.countryName);
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[loc.latitude doubleValue] longitude:[loc.longitude doubleValue]];
                    
                    [self previousLocations:location atCountry:loc.countryName andCity:loc.cityName];

                }
                
            }
        }
        

        if (self.places != 0) {
            
            for (CLPlacemark *place in self.places) {
                
                [self drawThisOnMapAt:place];
            }
        
    }

}

- (void)changePhoto{
    
    UIImagePickerController *imgControl = [[UIImagePickerController alloc] init];
    imgControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgControl.delegate = self;
    
    [self presentViewController:imgControl animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.userImg.image = info[UIImagePickerControllerOriginalImage];
    [self.changePhotoLbl setHidden:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:UIImagePNGRepresentation(self.userImg.image) forKey:@"userImage"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)previousLocations:(CLLocation *)place atCountry:(NSString *)country andCity:(NSString *)city{
    
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.02;
//    span.longitudeDelta = 0.02;
//    
//    MKCoordinateRegion region;
//    region.center = place.coordinate;
//    region.span = span;
//    
//    [self.mapView setRegion:region];
    
    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.coordinate = place.coordinate;
    ann.title = country;
    ann.subtitle = city;
    [self.mapView addAnnotation:ann];
    
    NSLog(@"set location");

}

-(void) drawThisOnMapAt:(CLPlacemark *) place {
    
    
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.02;
//    span.longitudeDelta = 0.02;
//    
//    MKCoordinateRegion region;
//    region.center = place.location.coordinate;
//    region.span = span;
//    
//    [self.mapView setRegion:region];
    
    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.coordinate = place.location.coordinate;
    ann.title = place.name;
    ann.subtitle = place.locality;
    [self.mapView addAnnotation:ann];
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation *)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    CustomPinView *pin = [[CustomPinView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    return pin;
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.manager startUpdatingLocation];
        self.locationAvail = YES;
    }else{
        
        self.locationAvail = NO;
    }
    
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
            MKCoordinateRegion theRegion = self.mapView.region;
            theRegion.center = aUserLocation.location.coordinate;
    
            theRegion.span.longitudeDelta *= 1.0;
            theRegion.span.latitudeDelta *= 1.0;
    
            [self.mapView setRegion:theRegion animated:YES];

    
    [self.manager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
