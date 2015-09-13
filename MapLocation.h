//
//  MapLocation.h
//  Travoto
//
//  Created by LT on 2015-09-13.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MapLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSString * cityName;

@end
