//
//  DataDownloader.m
//  Travoto
//
//  Created by Loanne Tran on 9/17/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "DataDownloader.h"

@implementation DataDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        dbh = [[DBHandler alloc]init];
        
    }
    return self;
}


-(void)downloadJSONDataForMapsAndUpdateDB{
    
    NSArray *fetchedObjects = [dbh fetchAllItemsFromEntityNamed:@"MapLocation"];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (MapLocation *loc in fetchedObjects) {
            
            if ([loc.latitude doubleValue] == 0 && [loc.longitude doubleValue] == 0) {
                
                AppDelegate *appD = [[UIApplication sharedApplication] delegate];
                
                if (appD.internetActive) {
                    
//                    NSURLSession *session = [NSURLSession sharedSession];
                    
                    NSString *country = [loc.countryName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *city = [loc.cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20geo.places%%20where%%20text%%3D%%22%@%%20%@%%22&format=json&diagnostics=true&callback=", country,city]];
                    
//                    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    if(data == nil)
                    {
                        NSLog(@"%@ %@", loc.countryName, loc.cityName);
                    }else{
                        NSError *error = nil;
                        NSDictionary *dict = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectForKey:@"query"] objectForKey:@"results"];
                        
                        NSString *lo;
                        NSNumber *lat;
                        NSNumber *longitude;
                        NSNumber *latitude;
                        
                        if([[dict objectForKey:@"place"] isKindOfClass:[NSArray class]])
                        {
                            NSDictionary *placeResult = [[dict objectForKey:@"place"] objectAtIndex:0];
                            
                            lo = [[placeResult objectForKey:@"centroid"] objectForKey:@"longitude"];
                            lat = [[placeResult objectForKey:@"centroid"] objectForKey:@"latitude"];
                            longitude = [NSNumber numberWithDouble:lo.doubleValue];
                            latitude = [NSNumber numberWithDouble:lat.doubleValue];
                            
                        }else{
                            
                            NSDictionary *placeResult = [dict objectForKey:@"place"];
                            
                            lo = [[placeResult objectForKey:@"centroid"] objectForKey:@"longitude"];
                            lat = [[placeResult objectForKey:@"centroid"] objectForKey:@"latitude"];
                            longitude = [NSNumber numberWithDouble:lo.doubleValue];
                            latitude = [NSNumber numberWithDouble:lat.doubleValue];
                            
                        }
                        
                        [self updateLongitude:longitude andLatitude:latitude inMapLocationWhereCityIs:loc.cityName];
                        
                    }
                    
                    
                        
//                    }];
                    
//                    [dataTask resume];
                }
            }
        }
    
    }
}

-(void)updateLongitude:(NSNumber *)longitude andLatitude:(NSNumber *)latitude inMapLocationWhereCityIs:(NSString *)city{
    
    NSArray *fetchedObjects = [dbh updateEntity:@"MapLocation" whereAttribute:@"cityName" isEqualTo:city];
    
    MapLocation *locationGrabbed = [fetchedObjects objectAtIndex:0];
    locationGrabbed.latitude = latitude;
    locationGrabbed.longitude = longitude;

    [dbh.cds saveContext];
}

@end
