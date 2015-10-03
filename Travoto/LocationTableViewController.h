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
#import "MapViewController.h"
#import "Country.h"
#import "City.h"
#import "Image.h"
#import "MapLocation.h"
#import "DBHandler.h"
#import "PretableSetUp.h"

@interface LocationTableViewController : UITableViewController <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate>{
    
    CLLocation *location; //location of image
//    NSDate *creationDate; //creation date of image
    NSString *currentCountry; //original text of entered country
    NSString *currentCity; //original text of entered city
    NSString *displayCountry; //how country name should be displayed formatted
    NSString *displayCity; //how city name should be displayed formatted
    NSString *keyCountry; //dictionary key of country
    NSString *keyCity; //dictionary key of city
    UIImage *img; //current image selected
    //    NSMutableDictionary *dateDict;
    NSString *selectedCountry;
    NSDictionary *selectedCity;
    UIAlertView *countryAlert;
    DBHandler *dbh;
    MapViewController *mVc;
    PretableSetUp *pre;
    UIActivityIndicatorView *progressView;
}

@property (nonatomic,strong) NSDictionary *countries;
@property (nonatomic,strong) CLGeocoder *coder;
@property (nonatomic,strong) NSMutableArray *savedLocations;
@property (nonatomic,strong) UIImage *cameraImage;
@property (nonatomic,strong) CLLocation *cameraLocation;
@property (nonatomic,strong) NSString *imgFileName;
@property (nonatomic,strong) NSArray *countryNames; //country names
@property (nonatomic,strong) NSArray *cityNames; //city names
@property (nonatomic,assign) BOOL inProgress;
@property (nonatomic,strong) NSMutableDictionary *filteredCountriesDict;
@property (nonatomic,strong) NSMutableArray *filteredCountryNames;
@property (nonatomic,strong) NSArray *sortedFilteredCountryNames;
@property IBOutlet UISearchBar *searchBar;


- (IBAction)addPhotos:(id)sender;

@end
