//
//  DBHandler.m
//  Travoto
//
//  Created by Loanne Tran on 9/13/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "DBHandler.h"

@implementation DBHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cds = [CoreDataStack dataStack];
    }
    return self;
}

-(NSArray *)fetchAllItemsFromEntityNamed:(NSString *)entityName{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.cds.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attr ascending:YES];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.cds.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


-(void)deleteAllObjectsIn:(NSString *)entity{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:entity inManagedObjectContext:self.cds.managedObjectContext];
    [fetchRequest setEntity:ent];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.cds.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (NSManagedObject *obj in fetchedObjects) {
            [self.cds.managedObjectContext deleteObject:obj];
        }
    }

    [self.cds saveContext];
}

-(void)deleteObjectIn:(NSString *)entity whereAttribute:(NSString *)attr isEqualTo:(NSString *)value{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:entity inManagedObjectContext:self.cds.managedObjectContext];
    [fetchRequest setEntity:ent];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == \"%@\"",attr,value]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.cds.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (NSManagedObject *obj in fetchedObjects) {
            [self.cds.managedObjectContext deleteObject:obj];
        }
    }
    
    [self.cds saveContext];
}

-(void)insertMapLocationForCountry:(NSString *)country andCity:(NSString *)city withLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lo{
    
    MapLocation *loc = [NSEntityDescription insertNewObjectForEntityForName:@"MapLocation" inManagedObjectContext:self.cds.managedObjectContext];
    
    loc.countryName = country;
    loc.cityName = city;
    loc.latitude = [NSNumber numberWithDouble:lat];
    loc.longitude = [NSNumber numberWithDouble:lo];
    
    [self.cds saveContext];
}

-(void)insertImageForDb:(UIImage *)imgToInsert withName:(NSString *)name{
    
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.cds.managedObjectContext];
    
    image.image = imgToInsert;
    image.imageName = name;
    
    [self.cds saveContext];
    
}

-(NSArray *)updateEntity:(NSString *)entity whereAttribute:(NSString *)attr isEqualTo:(NSString *)value{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.cds.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == \"%@\"",attr,value]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [self.cds.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    
    return fetchedObjects;
}

-(void)bulkInsertCountries:(NSArray *)countries{
    
    for (Country *c in countries) {
        
        Country *insertCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.cds.managedObjectContext];
        
        insertCountry.countryKey = c.countryKey;
        insertCountry.name = c.name;
        insertCountry.cities = c.cities;

    }
    
    [self.cds saveContext];
    
}

-(void)bulkInsertCities:(NSArray *)cities{
    
    for (City *ci in cities) {
        City *insertCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.cds.managedObjectContext];
        
        insertCity.name = ci.name;
        insertCity.cityKey = ci.cityKey;
        insertCity.images = ci.images;

    }
    
    [self.cds saveContext];
}

-(void)bulkInsertImages:(NSArray *)images{
    
    for (Image *im in images) {
        Image *insertImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.cds.managedObjectContext];
        insertImage.image = im.image;
        insertImage.imageName = im.imageName;

    }
    
    [self.cds saveContext];
    
}

-(NSDictionary *)createDictionaryFromCountries:(NSArray *)countries andCities:(NSArray *)cities andImages:(NSArray *)images{
    
    NSMutableDictionary *returnedDict = [[NSMutableDictionary alloc] init];
    
    for (Country *country in countries) {
        
        NSMutableDictionary *tempAttr = [[NSMutableDictionary alloc]init];
        
        NSArray *tempCityArray = [[country.cities componentsSeparatedByString:@","] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSMutableDictionary *tempCity = [[NSMutableDictionary alloc] init];
        
        for (NSString *c in tempCityArray) {
            
            for (int i=0; i<cities.count; i++) {
                
                City *cityGrabbed = [cities objectAtIndex:i];
                
                if ([cityGrabbed.cityKey isEqualToString:c]) {
                    NSMutableDictionary *tempCityAttr = [[NSMutableDictionary alloc]init];
                    [tempCityAttr setObject:cityGrabbed.name forKey:@"name"];
                    
                    NSArray *tempImgArray = [cityGrabbed.images componentsSeparatedByString:@","];
                    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
                    
                    for (NSString *imgName in tempImgArray) {
                        
                        for (int j=0; j<images.count; j++) {
                            
                            Image *imgGrabbed = [images objectAtIndex:j];
                            
                            if ([imgGrabbed.imageName isEqualToString:imgName]) {
                                [tempImages addObject:imgGrabbed.image];
                            }
                        }
                        
                    }
                    
                    [tempCityAttr setObject:tempImages forKey:@"images"];
                    [tempCity setObject:tempCityAttr forKey:cityGrabbed.cityKey];
                }
            }
        }
        
        [tempAttr setObject:country.name forKey:@"name"];
        [tempAttr setObject:tempCity forKey:@"cities"];
        [returnedDict setObject:tempAttr forKey:country.countryKey];
        
    }
    
    return returnedDict;
    
}

@end
