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
    // Do any additional setup after loading the view.
    
    self.manager = [[CLLocationManager alloc] init];
    self.coder = [[CLGeocoder alloc]init];
    self.manager.delegate = self;
    [self.userImg.layer setCornerRadius:60];
    [self.userImg setClipsToBounds:YES];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
//    if (![[def objectForKey:@"login"] isEqualToString:@"done"]) {
//        
//        [self performSegueWithIdentifier:@"login" sender:self];
//    }
    
    if ([def objectForKey:@"userImage"]) {
        
        NSData* imageData = [def objectForKey:@"userImage"];
        self.userImg.image = [UIImage imageWithData:imageData];
        [self.changePhotoLbl setHidden:YES];
    }
    
    if ([def objectForKey:@"name"]) {
        self.welcomeLbl.text = [NSString stringWithFormat:@"Welcome %@",[def objectForKey:@"name"]];
    }
    
    if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                   to:self.manager
                                                 from:self
                                             forEvent:nil];
    } else {
        self.mapView.showsUserLocation = YES;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.manager.location.coordinate, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        [self.manager startUpdatingLocation];
    }
    
    UITapGestureRecognizer *lblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    
    [self.changePhotoLbl addGestureRecognizer:lblGesture];
    UITapGestureRecognizer *photoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    [self.userImg addGestureRecognizer:photoGesture];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
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

-(void) drawThisOnMapAt:(CLPlacemark *) place {
    
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    MKCoordinateRegion region;
    region.center = place.location.coordinate;
    region.span = span;
    
    [self.mapView setRegion:region];
    
    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.coordinate = place.location.coordinate;
    ann.title = place.name;
    ann.subtitle = place.locality;
    [self.mapView addAnnotation:ann];
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    CustomPinView *pin = [[CustomPinView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    return pin;
    
    
    //default pins
    //    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    //
    //    view.pinColor = MKPinAnnotationColorPurple;
    //    view.enabled = YES;
    //    view.canShowCallout = YES;
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img7.png"]];
    //    view.leftCalloutAccessoryView = imageView;
    //
    //    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    
    //    return view;
    
}
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Hello Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alert show];
//    
//}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {

        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.manager.location.coordinate, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
//        [self.coder geocodeAddressString:@"toronto"
//                       completionHandler:^(NSArray *placemarks, NSError *error) {
//                           if(!error){
//                               
//                               CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                               [self drawThisOnMapAt:placemark];
//                               NSLog(@"%lu",(unsigned long)placemarks.count);
////                               NSLog(@"%@",placemark);
//                               
//                           } else {
//                               NSLog(@"%@",[error description]);
//                           }
//                       }];

        [self.manager startUpdatingLocation];
    }
    
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
