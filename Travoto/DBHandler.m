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



@end
