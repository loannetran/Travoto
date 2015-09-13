//
//  Country.h
//  Travoto
//
//  Created by Loanne Tran on 9/12/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cities;
@property (nonatomic, retain) NSString * countryKey;

@end
