//
//  Image.h
//  Travoto
//
//  Created by Loanne Tran on 9/12/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) id image;

@end
