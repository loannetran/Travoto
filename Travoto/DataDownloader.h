//
//  DataDownloader.h
//  Travoto
//
//  Created by Loanne Tran on 9/17/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandler.h"
#import "AppDelegate.h"

@interface DataDownloader : NSObject{
    
    DBHandler *dbh;
}

-(void)downloadJSONDataForMapsAndUpdateDB;

@end
