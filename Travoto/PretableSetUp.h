//
//  PretableSetUp.h
//  Travoto
//
//  Created by Loanne Tran on 9/15/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import "AlbumViewController.h"
#import <MapKit/MKAnnotation.h>
#import "MapAnnotation.h"
#import "MapViewController.h"
#import "CoreDataStack.h"
#import "Country.h"
#import "City.h"
#import "Image.h"
#import "MapLocation.h"
#import "DBHandler.h"

@interface PretableSetUp : NSObject <UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    
    CLLocation *location; //location of image
    NSDate *creationDate; //creation date of image
    NSString *currentCountry; //original text of entered country
    NSString *currentCity; //original text of entered city
    NSString *keyCountry; //dictionary key of country
    NSString *keyCity; //dictionary key of city
    UIImage *img; //current image selected
    //    NSMutableDictionary *dateDict;
    NSMutableDictionary *cityDict; //dictionary of cities
    NSMutableArray *images; //dictionary of images
    NSMutableDictionary *countryAttr; //country attributes
    NSMutableDictionary *cityAttr; //city attributes
    NSMutableArray *countryNames; //country names
    NSMutableArray *cityNames; //city names
//    NSArray *sortedCountryNames; //sorted country names
//    NSArray *sortedCityNames; //sorted city names
    NSString *selectedCountry;
    NSDictionary *selectedCity;
    UIAlertView *countryAlert;
    DBHandler *dbh;
    MapViewController *mVc;
    NSMutableArray *reqCountries;
    NSMutableArray *reqCities;
    NSMutableArray *reqImages;
    UIActivityIndicatorView *progressView;
    BOOL inProgress;

}

@property (nonatomic,strong) NSMutableDictionary *countries;
@property (nonatomic,strong) CLGeocoder *coder;
@property (nonatomic,strong) NSMutableArray *savedLocations;
@property (nonatomic,strong) UIImage *cameraImage;
@property (nonatomic,strong) CLLocation *cameraLocation;
@property (nonatomic,strong) NSString *imgFileName;
@property (nonatomic,strong) NSArray *sortedCountryNames;
@property (nonatomic,strong) NSArray *sortedCityNames;

-(void)removeEverythingFromDB;
-(NSDictionary *)getAllEntitiesFromDB;
-(void)reinitializeCountries:(NSDictionary *)countries;
-(NSDictionary *)setUpTableValuesForDictionary:(NSDictionary *)countries countryName:(NSString *)countryName withCountryDisplay:(NSString *)displayCountry cityName:(NSString *)cityName withCityDisplay:(NSString *)displayCity imgName:(NSString *)imgName andImage:(UIImage *)image;

@end
