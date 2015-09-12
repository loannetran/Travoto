//
//  MapAnnotation.h
//  MapApp
//
//  Created by Vivian Aranha on 8/31/15.
//  Copyright (c) 2015 Vivian Aranha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
