//
//  PretableSetUp.m
//  Travoto
//
//  Created by Loanne Tran on 9/15/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "PretableSetUp.h"

@implementation PretableSetUp

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countries = [[NSMutableDictionary alloc] init];
        dbh = [[DBHandler alloc] init];
        countryNames = [[NSMutableArray alloc] init];
        cityNames = [[NSMutableArray alloc] init];

    }
    return self;
}

-(void)removeEverythingFromDB{
    
    [dbh deleteAllObjectsIn:@"Country"];
    [dbh deleteAllObjectsIn:@"City"];
    [dbh deleteAllObjectsIn:@"Image"];
    [dbh deleteAllObjectsIn:@"MapLocation"];
    
}

-(NSDictionary *)getAllEntitiesFromDB{
    
    //get all data from database and put in array
    NSArray *fetchedObjects = [dbh fetchAllItemsFromEntityNamed:@"Country"];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        
        reqCountries = [[NSMutableArray alloc] initWithArray:fetchedObjects];
        
    }
    
    fetchedObjects = [dbh fetchAllItemsFromEntityNamed:@"City"];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        reqCities = [[NSMutableArray alloc] initWithArray:fetchedObjects];
        
    }
    
    fetchedObjects = [dbh fetchAllItemsFromEntityNamed:@"Image"];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        
        reqImages = [[NSMutableArray alloc] initWithArray:fetchedObjects];
        
    }
    
    if (reqCountries != nil) {
        self.countries = [[dbh createDictionaryFromCountries:reqCountries andCities:reqCities andImages:reqImages] mutableCopy];
    }
    
    
    return self.countries;
    
}

-(NSDictionary *)setUpTableValuesForDictionary:(NSDictionary *)countries countryName:(NSString *)countryName withCountryDisplay:(NSString *)displayCountry cityName:(NSString *)cityName withCityDisplay:(NSString *)displayCity imgName:(NSString *)imgName andImage:(UIImage *)image{
    
    NSMutableDictionary *returnedDictionary;
    
    if (countries.count > 0) {
        
        returnedDictionary = [[NSMutableDictionary alloc] initWithDictionary:countries];
        
    }else{
        
        returnedDictionary = [[NSMutableDictionary alloc] init];
    }
    
    //if country exists
    
    if ([countries objectForKey:countryName]) {
        
        //        NSLog(@"country exists");
        
        //if city for country exists
        
        if ([[[countries objectForKey:countryName] objectForKey:@"cities"] objectForKey:cityName]) {
            
            //            NSLog(@"city exists");
            
            //get dictionary for current country
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[countries objectForKey:countryName]];
            
            //if there are images in city
            
            if ([[[countries objectForKey:countryName] objectForKey:@"cities"] objectForKey:cityName] != 0) {
                
                NSMutableArray *tempImages = [[[tempDict objectForKey:@"cities"] objectForKey:cityName] objectForKey:@"images"];
                
                NSData *newImg = UIImagePNGRepresentation(image);
                
                BOOL imgExists = NO;
                
                for (int i = 0; i<tempImages.count; i++) {
                    
                    NSData *oldImg = UIImagePNGRepresentation([tempImages objectAtIndex:i]);
                    
                    if ([newImg isEqual:oldImg]) {
                        
                        imgExists = YES;
                        break;
                        
                    }else{
                        imgExists = NO;
                    }
                    
                }
                
                if (!imgExists) {
                    
                    [[[[tempDict objectForKey:@"cities"] objectForKey:cityName] objectForKey:@"images"] addObject:image];
                    
                    //set dictionary with changes
                    
                    [returnedDictionary setObject:tempDict forKey:countryName];
                    
                    
                    NSArray *currentImageArray = [[[[countries objectForKey:countryName] objectForKey:@"cities"] objectForKey:cityName] objectForKey:@"images"];
                    
                    long imgCount = currentImageArray.count;
                    
                    self.imgFileName = [NSString stringWithFormat:@"%@_%li",imgName,imgCount];
                    
                    [dbh insertImageForDb:image withName:self.imgFileName];
                    
                    NSArray *fetchedObjects = [dbh updateEntity:@"City" whereAttribute:@"cityKey" isEqualTo:cityName];
                    
                    if (fetchedObjects == nil) {
                        
                        NSLog(@"Error");
                        
                    } else {
                        
                        City *cityGrabbed = [fetchedObjects objectAtIndex:0];
                        
                        NSString *imgString = cityGrabbed.images;
                        
                        cityGrabbed.images = [imgString stringByAppendingString:[NSString stringWithFormat:@",%@",self.imgFileName]];
                        
                        [dbh.cds saveContext];
                        
                    }
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Image" message:@"Image already exists within collection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    [alert show];
                }
                
            }
            
        }
        //if city for country does not exist
        else{
            
            //get dictionary for current country
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[countries objectForKey:countryName]];
            
            //create image array
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            [tempArray addObject:image];
            
            //create cityAttr dictionary and images and name
            
            NSMutableDictionary *tempAttrDict = [[NSMutableDictionary alloc] init];
            
            [tempAttrDict setObject:displayCity forKey:@"name"];
            
            [tempAttrDict setObject:tempArray forKey:@"images"];
            
            //add city with attribute array
            
            [[tempDict objectForKey:@"cities"] setValue:tempAttrDict forKey:cityName];
            
            
            //set dictionary with changes
            
            [returnedDictionary setObject:tempDict forKey:countryName];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [dbh updateEntity:@"Country" whereAttribute:@"countryKey" isEqualTo:countryName];
            
            if (fetchedObjects == nil) {
                
                NSLog(@"%@", error);
                
            }else {
                
                Country *countryGrabbed = [fetchedObjects objectAtIndex:0];
                
                NSString *cityString = countryGrabbed.cities;
                
                countryGrabbed.cities = [cityString stringByAppendingString:[NSString stringWithFormat:@",%@",cityName]];
                
                //                NSLog(@"%@", countryGrabbed.cities);
                
            }
            
            
            
            City *insertCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:dbh.cds.managedObjectContext];
            
            insertCity.name = displayCity;
            
            insertCity.cityKey = cityName;
            
            insertCity.images = [NSString stringWithFormat:@"%@",imgName];
            
            
            
            [dbh insertImageForDb:image withName:imgName];
            
            [dbh.cds saveContext];
            
            UIAlertView *alertLoc = [[UIAlertView alloc] initWithTitle:@"New Location!" message:[NSString stringWithFormat:@"Country: %@\nCity: %@", displayCountry, displayCity] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertLoc show];
            
        }
    }else{
        
        //if country does not exist
        images = [[NSMutableArray alloc] init];
        
        [images addObject:image];
        
        cityAttr = [[NSMutableDictionary alloc] init];
        
        [cityAttr setObject:displayCity forKey:@"name"];
        
        [cityAttr setObject:images forKey:@"images"];
        
        
        
        cityDict = [[NSMutableDictionary alloc] init];
        
        [cityDict setObject:cityAttr forKey:cityName];
        
        
        
        countryAttr = [[NSMutableDictionary alloc] init];
        
        
        
        [countryAttr setObject:displayCountry forKey:@"name"];
        
        [countryAttr setObject:cityDict forKey:@"cities"];
        
        
        
        [returnedDictionary setObject:countryAttr forKey:countryName];
        
        
        
        [dbh insertImageForDb:image withName:imgName];
        
        
        
        Country *insertCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:dbh.cds.managedObjectContext];
        
        insertCountry.countryKey = countryName;
        
        insertCountry.name = displayCountry;
        
        insertCountry.cities = [NSString stringWithFormat:@"%@",cityName];
        
        
        
        
        
        City *insertCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:dbh.cds.managedObjectContext];
        
        
        
        insertCity.name = displayCity;
        
        insertCity.cityKey = cityName;
        
        insertCity.images = [NSString stringWithFormat:@"%@",imgName];
        
        
        
        [dbh.cds saveContext];
        
        
        
        UIAlertView *alertLoc = [[UIAlertView alloc] initWithTitle:@"New Location!" message:[NSString stringWithFormat:@"Country: %@\nCity: %@", displayCountry, displayCity] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        
        
        [alertLoc show];
        
    }
    
    return returnedDictionary;
}



-(void)reinitializeCountries:(NSDictionary *)countries{
    
    if (countries.count > 0) {
        
        BOOL countryExists = NO;
        
        for (NSString *c in countries) {
            
            for (NSString *name in countryNames) {
                
                if ([name isEqual:c]) {
                    
                    countryExists = YES;
                    break;
                }else{
                    countryExists = NO;
                }
            }
            
            if (!countryExists) {
                [countryNames addObject:c];
                for (NSString *city in [[countries objectForKey:c] objectForKey:@"cities"]) {
                    [cityNames addObject:city];
                }
            }else{
                
                BOOL cityExists = NO;
                
                for (NSString *ci in [[countries objectForKey:c] objectForKey:@"cities"]) {
                    
                    for (NSString *ciName in cityNames) {
                        
                        if ([ciName isEqualToString:ci]) {
                            
                            cityExists = YES;
                            break;
                        }else{
                            cityExists = NO;
                        }
                    }
                    
                    if (!cityExists) {
                        [cityNames addObject:ci];
                    }
                }
                
            }
            
        }
        
    }else{
        
        for (NSString *country in self.countries) {
            [countryNames addObject:country];
            for (NSString *city in [[self.countries objectForKey:country] objectForKey:@"cities"]) {
                [cityNames addObject:city];
            }
        }
        
    }
    
    self.sortedCountryNames = [countryNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.sortedCityNames = [cityNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
}


@end
