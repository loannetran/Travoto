//
//  City.h
//  Travoto
//
//  Created by Loanne Tran on 9/12/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSString * cityKey;

@end
