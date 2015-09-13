//
//  LocationTableViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "LocationTableViewController.h"

@interface LocationTableViewController (){
    
    CLLocation *location; //location of image
    NSDate *creationDate; //creation date of image
    NSString *currentCountry; //original text of entered country
    NSString *currentCity; //original text of entered city
    NSString *displayCountry; //how country name should be displayed formatted
    NSString *displayCity; //how city name should be displayed formatted
    NSString *keyCountry; //dictionary key of country
    NSString *keyCity; //dictionary key of city
    UIImage *img; //current image selected
    //    NSMutableDictionary *dateDict;
    NSMutableDictionary *cityDict; //dictionary of cities
    NSMutableArray *images; //dictionary of images
    NSMutableDictionary *countryAttr; //country attributes
    NSMutableDictionary *cityAttr; //city attributes
    NSMutableArray *countryNames; //country names
    NSMutableArray *cityNames; //city names
    NSArray *sortedCountryNames; //sorted country names
    NSArray *sortedCityNames; //sorted city names
    NSString *selectedCountry;
    NSDictionary *selectedCity;
    UIAlertView *countryAlert;
    CoreDataStack *cds;
    NSString *imgFileName;
    NSMutableArray *reqCountries;
    NSMutableArray *reqCities;
    NSMutableArray *reqImages;

    
}

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [[NSMutableDictionary alloc] init];
    self.savedLocations = [[NSMutableArray alloc] init];
    self.coder = [[CLGeocoder alloc]init];
    
    cds = [CoreDataStack dataStack];
    
//    NSLog(@"current image: %@",self.cameraImage);
//    NSLog(@"current location: %@",self.cameraLocation);
    
    NSLog(@"view loaded");
    //    dateDict = [[NSMutableDictionary alloc] init];
    [self getAllNamesFromDB];
    [self reinitializeCountriesAndCities];
}

-(void)removeEverythingFromDB{
    
    NSFetchRequest *req = [cds.managedObjectModel fetchRequestTemplateForName:@"allCountries"];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (NSManagedObject *c in fetchedObjects) {
            [cds.managedObjectContext deleteObject:c];
        }
//        NSLog(@"%@", fetchedObjects);
    }
    
    req = [cds.managedObjectModel fetchRequestTemplateForName:@"allCities"];
    
    fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (NSManagedObject *c in fetchedObjects) {
            
            [cds.managedObjectContext deleteObject:c];
            
        }
//        NSLog(@"%@",fetchedObjects);
    }
    
    req = [cds.managedObjectModel fetchRequestTemplateForName:@"allImages"];
    
    fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (NSManagedObject *i in fetchedObjects) {
            [cds.managedObjectContext deleteObject:i];
        }
//        NSLog(@"%@",fetchedObjects);
    }
    
    [cds saveContext];

}

-(void)getAllNamesFromDB{
    
    reqCountries = [[NSMutableArray alloc] init];
    reqCities = [[NSMutableArray alloc] init];
    reqImages = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *req = [cds.managedObjectModel fetchRequestTemplateForName:@"allCountries"];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (Country *c in fetchedObjects) {
            
            [reqCountries addObject:c];
            NSLog(@"%@",c.name);
        }
    }
    
    req = [cds.managedObjectModel fetchRequestTemplateForName:@"allCities"];
    
    fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (City *c in fetchedObjects) {
            
            [reqCities addObject:c];
        NSLog(@"%@",c.name);
            
        }

    }
    
    req = [cds.managedObjectModel fetchRequestTemplateForName:@"allImages"];
    
    fetchedObjects = [cds.managedObjectContext executeFetchRequest:req error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
    } else {
        for (Image *i in fetchedObjects) {
            
            [reqImages addObject:i];
        NSLog(@"%@",i.imageName);
        }

    }
    
    [self allocateValuesFromDB];
    
}

-(void)allocateValuesFromDB{
    
    for (Country *country in reqCountries) {
        
        NSMutableDictionary *tempAttr = [[NSMutableDictionary alloc]init];
        [tempAttr setObject:country.name forKey:@"name"];
        
        NSArray *tempCityArray = [[country.cities componentsSeparatedByString:@","] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSMutableDictionary *tempCity = [[NSMutableDictionary alloc] init];
        
        for (NSString *c in tempCityArray) {
            
            for (City *city in reqCities) {
                
                if ([city.cityKey isEqualToString:c]) {
                    
                    NSMutableDictionary *tempCityAttr = [[NSMutableDictionary alloc]init];
                    [tempCityAttr setObject:city.name forKey:@"name"];
                    
                    NSArray *tempImgArray = [city.images componentsSeparatedByString:@","];
                    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
                    
                    for (NSString *imgName in tempImgArray) {
                        
                        for (Image *i in reqImages) {
                            
                            if ([i.imageName isEqualToString:imgName]) {
                                
                                [tempImages addObject:i.image];
                            }
                        }
                    }
                    
                    [tempCityAttr setObject:tempImages forKey:@"images"];
                    [tempCity setObject:tempCityAttr forKey:city.cityKey];
                }
            }
        }
        
        [tempAttr setObject:tempCity forKey:@"cities"];
        [self.countries setObject:tempAttr forKey:country.countryKey];

    }
    
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    if (self.cameraImage != nil) {
        [self setUpImage:self.cameraImage andLocation:self.cameraLocation];
    }

}

- (IBAction)addPhotos:(id)sender {
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)alertForLocation{
    
    countryAlert = [[UIAlertView alloc] initWithTitle:@"Location" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    
    countryAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [countryAlert textFieldAtIndex:0].placeholder = @"Country";
    [countryAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeYes;
    [countryAlert textFieldAtIndex:1].autocorrectionType = UITextAutocorrectionTypeYes;
    [countryAlert textFieldAtIndex:1].placeholder = @"City, (optional: Address)";
    [countryAlert textFieldAtIndex:1].secureTextEntry = NO;

}

-(void)lookUpLocationWithCLLocation:(CLLocation *)loc{
    
    [self.coder reverseGeocodeLocation:loc
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if(!error){
                             
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             
                             [self.savedLocations addObject:placemark];
                             
                             currentCountry = placemark.country;
                             currentCity = placemark.locality;
                             
                             displayCountry = currentCountry;
                             displayCity = currentCity;
                             
                             keyCountry = [[currentCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                             keyCity = [[currentCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                             
                             //                                     NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, .8)];
//                             [self setUpImageForDb:img withName:imgFileName];
                             [self setUpTableValues];
                             [self reinitializeCountriesAndCities];
                             
                             //                                         NSLog(@"%@",[placemarks objectAtIndex:0]);
                             
                         } else {
                             NSLog(@"%@",[error description]);
                         }
                     }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    [self alertForLocation];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        creationDate = [myasset valueForProperty:ALAssetPropertyDate];
        location = [myasset valueForProperty:ALAssetPropertyLocation];
        //set image to be original image
        img = info[UIImagePickerControllerOriginalImage];

        ALAssetRepresentation *imageRep = [myasset defaultRepresentation];
        //set image file name
        imgFileName = [imageRep filename];

//        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        
        //if location is not detected in image
        if (location == nil) {
            
            //show manual entry for location
            [countryAlert show];
            
//            [self setUpImageForDb:img withName:imgFileName];
            
        }else{
            
            //if location is found in image
            [self lookUpLocationWithCLLocation:location];
        }
        
//        NSLog(@"%@", [myasset valueForProperty:ALAssetPropertyLocation]);
    };
    // This block will handle errors:
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
        // Do something to handle the error
    };
    
    // Use the url to get the asset from ALAssetsLibrary,
    // the blocks that we just created will handle results
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:url
                   resultBlock:resultblock
                  failureBlock:failureblock];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        currentCountry = [alertView textFieldAtIndex:0].text;
        currentCity = [alertView textFieldAtIndex:1].text;
        
        //        NSLog(@"%@ %@", currentCountry, currentCity);
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[countryAlert textFieldAtIndex:0].text length] > 0 && [[countryAlert textFieldAtIndex:1].text length] > 0)
        {
            NSString *place = [NSString stringWithFormat:@"%@ %@",currentCity, currentCountry];
            
            [self lookUpLocationWithString:place];
        }else{
            
            countryAlert.message = @"Please enter a location";
            [countryAlert show];
        }

    }
}

-(void)lookUpLocationWithString:(NSString *)locString{
    
    [self.coder geocodeAddressString:locString
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(!error){
                           
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           [self.savedLocations addObject:placemark];
                           displayCountry = placemark.country;
                           displayCity = placemark.locality;
                           keyCountry = [[displayCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                           keyCity = [[displayCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                           [self setUpTableValues];
                           [self reinitializeCountriesAndCities];
                           
                       } else {
                           
                           NSLog(@"%@",[error description]);
                           countryAlert.message = @"Invalid location please re-enter location";
                           [countryAlert show];
                           
                       }
                   }];

}

-(void)setUpTableValues{
    
    //if country exists
    if ([self.countries objectForKey:keyCountry]) {
        //        NSLog(@"country exists");
        
        //if city for country exists
        if ([[[self.countries objectForKey:keyCountry] objectForKey:@"cities"] objectForKey:keyCity]) {
            //            NSLog(@"city exists");
            
            //get dictionary for current country
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[self getDictForCountry:keyCountry]];
            
            //if there are images in city
            if ([[[self.countries objectForKey:keyCountry] objectForKey:@"cities"] objectForKey:keyCity] != 0) {
                
                [[[[tempDict objectForKey:@"cities"] objectForKey:keyCity] objectForKey:@"images"] addObject:img];
                
                //set dictionary with changes
                [self.countries setObject:tempDict forKey:keyCountry];
                
                NSArray *fetchedObjects = [cds updateEntity:@"City" whereAttribute:@"cityKey" isEqualTo:keyCity];
                
                if (fetchedObjects == nil) {
                    NSLog(@"Error");
                } else {
                    
                    City *cityGrabbed = [fetchedObjects objectAtIndex:0];
                    NSString *imgString = cityGrabbed.images;
                    cityGrabbed.images = [imgString stringByAppendingString:[NSString stringWithFormat:@"%@,",imgFileName]];
                    
                    [cds saveContext];
                }
                
                [self setUpImageForDb:img withName:imgFileName];
                
            }
        }
        //if city for country does not exist
        else{
            
            City *insertCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:cds.managedObjectContext];
            
            insertCity.name = displayCity;
            insertCity.cityKey = keyCity;
            insertCity.images = [NSString stringWithFormat:@"%@,",imgFileName];

            NSError *error = nil;
            
            NSArray *fetchedObjects = [cds updateEntity:@"Country" whereAttribute:@"countryKey" isEqualTo:keyCountry];
            if (fetchedObjects == nil) {
                NSLog(@"%@", error);
            }else {
                
                Country *countryGrabbed = [fetchedObjects objectAtIndex:0];
                NSString *cityString = countryGrabbed.cities;
                countryGrabbed.cities = [cityString stringByAppendingString:[NSString stringWithFormat:@"%@,",keyCity]];
                
                [cds saveContext];
                
//                NSLog(@"%@", countryGrabbed.cities);
            }
            
            [self setUpImageForDb:img withName:imgFileName];
            
            //get dictionary for current country
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[self getDictForCountry:keyCountry]];
            
            //create image array
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:img];
            
            //create cityAttr dictionary and images and name
            NSMutableDictionary *tempAttrDict = [[NSMutableDictionary alloc] init];
            [tempAttrDict setObject:displayCity forKey:@"name"];
            [tempAttrDict setObject:tempArray forKey:@"images"];
            
            //add city with attribute array
            [[tempDict objectForKey:@"cities"] setValue:tempAttrDict forKey:keyCity];
            
            //set dictionary with changes
            [self.countries setObject:tempDict forKey:keyCountry];
            
            UIAlertView *alertLoc = [[UIAlertView alloc] initWithTitle:@"New Location!" message:[NSString stringWithFormat:@"Country: %@\nCity: %@", displayCountry, displayCity] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertLoc show];
            
        }
        
    }else{
        
        //if country does not exist
        
        images = [[NSMutableArray alloc] init];
        [images addObject:img];
        
        cityAttr = [[NSMutableDictionary alloc] init];
        [cityAttr setObject:displayCity forKey:@"name"];
        [cityAttr setObject:images forKey:@"images"];
        
        cityDict = [[NSMutableDictionary alloc] init];
        [cityDict setObject:cityAttr forKey:keyCity];
        
        countryAttr = [[NSMutableDictionary alloc] init];
        
        [countryAttr setObject:displayCountry forKey:@"name"];
        [countryAttr setObject:cityDict forKey:@"cities"];
        
        [self.countries setObject:countryAttr forKey:keyCountry];
        
        [self setUpImageForDb:img withName:imgFileName];
        
        Country *insertCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:cds.managedObjectContext];
        insertCountry.countryKey = keyCountry;
        insertCountry.name = displayCountry;
        insertCountry.cities = [NSString stringWithFormat:@"%@,",keyCity];
        
        City *insertCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:cds.managedObjectContext];
        
        insertCity.name = displayCity;
        insertCity.cityKey = keyCity;
        insertCity.images = [NSString stringWithFormat:@"%@,",imgFileName];
        
        [cds saveContext];
        
        UIAlertView *alertLoc = [[UIAlertView alloc] initWithTitle:@"New Location!" message:[NSString stringWithFormat:@"Country: %@\nCity: %@", displayCountry, displayCity] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertLoc show];
    }
    
    [self getAllNamesFromDB];
    
}


-(void)setUpImageForDb:(UIImage *)imgToInsert withName:(NSString *)name{
    
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:cds.managedObjectContext];
    
    image.image = imgToInsert;
    image.imageName = name;
    
    [cds saveContext];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //number of sections depends on number of countries
    return self.countries.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //loop through countries to get each number of city count
    for (int i=0; i<sortedCountryNames.count; i++) {
        
        if (section == i) {
            
            NSDictionary *temp = [[NSDictionary alloc] initWithDictionary:[[self.countries objectForKey:[sortedCountryNames objectAtIndex:i]] objectForKey:@"cities"]];
            return temp.count;
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city" forIndexPath:indexPath];
    
    //temp array to add all cities in current country/section
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSString *s in [[self.countries objectForKey:[sortedCountryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"]) {
        
        [temp addObject:s];
    }
    
    //sort array
    NSArray *tempArray = [temp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //set label for each cell according to each section and row
    cell.textLabel.text = [[[[self.countries objectForKey:[sortedCountryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"] objectForKey:[tempArray objectAtIndex:indexPath.row]] objectForKey:@"name"];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:17]];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:54.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:19]];
    [header.textLabel setShadowColor: [UIColor whiteColor]];
    [header.textLabel setShadowOffset: CGSizeMake(0, -1.0)];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    //     header.contentView.backgroundColor = [UIColor blackColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //51 204 204

    
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Country" inManagedObjectContext:cds.managedObjectContext]];
//            
//        NSError *error = nil;
//            
//        NSArray *fetchedObjects = [cds.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//        if (fetchedObjects == nil) {
//                NSLog(@"%@", error);
//        }else{
//            NSMutableArray *arrayOfCountries;
//        for (Country *c in fetchedObjects) {
//
//            arrayOfCountries = [[NSMutableArray alloc] init];
//            [arrayOfCountries addObject:c.name];
//            
//        }
//            
//        NSArray *sortedTemp = [arrayOfCountries sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
//        
//            return [sortedTemp objectAtIndex:section];

    
            return [[self.countries objectForKey:[sortedCountryNames objectAtIndex:section]] objectForKey:@"name"];
    
//    return @"section";
}

-(void)setUpImage:(UIImage *)image andLocation:(CLLocation *)loc{

    [self.coder reverseGeocodeLocation:loc
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if(!error){
                             
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             
                             [self.savedLocations addObject:placemark];
                             
                             currentCountry = placemark.country;
                             currentCity = placemark.locality;
                             
                             displayCountry = [currentCountry capitalizedString];
                             displayCity = [currentCity capitalizedString];
                             
                             keyCountry = [[currentCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                             keyCity = [[currentCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                             
                             img = image;
                             
                             UIImageWriteToSavedPhotosAlbum(image,self,nil,nil);
                             
                             [self setUpTableValues];
                             [self reinitializeCountriesAndCities];
                             
                             //                                         NSLog(@"%@",[placemarks objectAtIndex:0]);
                             
                             
                         } else {
                             NSLog(@"%@",[error description]);
                         }
                     }];

    
    self.cameraImage = nil;
    self.cameraLocation = nil;
    
    
}

-(NSDictionary *)getDictForCountry:(NSString *)country{
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *d in self.countries) {
        
        if ([[self.countries objectForKey:country] isEqual:[self.countries objectForKey:d]]) {
            
            temp = [self.countries objectForKey:d];
        }
    }
    
    return temp;
}

-(void)reinitializeCountriesAndCities{
    
    countryNames = [[NSMutableArray alloc] init];
    cityNames = [[NSMutableArray alloc] init];
    
    for (NSString *country in self.countries) {
        [countryNames addObject:country];
        for (NSString *city in [[self.countries objectForKey:country] objectForKey:@"cities"]) {
            [cityNames addObject:city];
        }
    }
    
    sortedCountryNames = [countryNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    sortedCityNames = [cityNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //        NSLog(@"%@", sortedCountryNames);
    //        NSLog(@"%@", sortedCityNames);
    
//    MapViewController *mVc = [[self.tabBarController viewControllers] objectAtIndex:0];
//    
//    mVc.places = self.savedLocations;
    
    [self.tableView reloadData];

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    selectedCountry = [sortedCountryNames objectAtIndex:indexPath.section];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSString *s in [[self.countries objectForKey:selectedCountry] objectForKey:@"cities"]) {
        
        [temp addObject:s];
    }
    
    //sort array
    NSArray *tempArray = [temp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //set label for each cell according to each section and row
    selectedCity = [[[self.countries objectForKey:[sortedCountryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"] objectForKey:[tempArray objectAtIndex:indexPath.row]];
    
    
    //    NSLog(@"%@", selectedCity);
    
    
    
    AlbumViewController *aVc = segue.destinationViewController;
    
    aVc.country = [[self.countries objectForKey:selectedCountry] objectForKey:@"name"];
    aVc.city = selectedCity;
    
    
    //     NSLog(@"%@ %@", aVc.country, aVc.city);
}



@end
