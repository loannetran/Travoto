//
//  DBHandler.h
//  Travoto
//
//  Created by Loanne Tran on 9/13/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "MapLocation.h"
#import "Country.h"
#import "City.h"
#import "Image.h"
#import <MapKit/MapKit.h>

@interface DBHandler : NSObject

@property (nonatomic, strong) CoreDataStack *cds;

-(NSArray *)fetchAllItemsFromEntityNamed:(NSString *)entityName;
-(void)deleteAllObjectsIn:(NSString *)entity;
-(void)deleteObjectIn:(NSString *)entity whereAttribute:(NSString *)attr isEqualTo:(NSString *)value;
-(void)insertImageForDb:(UIImage *)imgToInsert withName:(NSString *)name;
-(void)insertMapLocationForCountry:(NSString *)country andCity:(NSString *)city withLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lo;
-(NSArray *)updateEntity:(NSString *)entity whereAttribute:(NSString *)attr isEqualTo:(NSString *)value;
-(NSDictionary *)createDictionaryFromCountries:(NSArray *)countries andCities:(NSArray *)cities andImages:(NSArray *)images;

@end
