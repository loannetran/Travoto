    //
//  LocationTableViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "LocationTableViewController.h"

@interface LocationTableViewController (){
    
    NSOperationQueue *theQueue;
    AppDelegate *appDelegate;
}

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //----initializing variables
    self.countries = [[NSMutableDictionary alloc] init];
    self.savedLocations = [[NSMutableArray alloc] init];
    self.coder = [[CLGeocoder alloc]init];
    dbh = [[DBHandler alloc] init];
    mVc = [[self.tabBarController viewControllers] objectAtIndex:0];
    pre = [[PretableSetUp alloc]init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    theQueue = [[NSOperationQueue alloc] init];
    inProgress = NO;
    
    //for sequential threading
//    theQueue.maxConcurrentOperationCount = 1;

    [self setUpAlertForLocation];
    self.countries = [[pre getAllEntitiesFromDB] mutableCopy];
    [pre reinitializeCountries:self.countries];
    self.countryNames = pre.sortedCountryNames;
    self.cityNames = pre.sortedCityNames;
    [self.tableView reloadData];
//    [pre removeEverythingFromDB];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.tabBarController.tabBar setHidden:NO];
    if (self.cameraImage != nil) {
        inProgress = YES;
        [self.tableView reloadData];

        if (self.cameraLocation == nil) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:0 longitude:0];
            self.cameraLocation = loc;
        }
        
        [self setUpImage:self.cameraImage andLocation:self.cameraLocation];
        
    }
}

- (IBAction)addPhotos:(id)sender {
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
//        creationDate = [myasset valueForProperty:ALAssetPropertyDate];
        location = [myasset valueForProperty:ALAssetPropertyLocation];
        //set image to be original image
        img = info[UIImagePickerControllerOriginalImage];
        
        ALAssetRepresentation *imageRep = [myasset defaultRepresentation];
        //set image file name
        self.imgFileName = [imageRep filename];
        
        //if location is not detected in image
        if (location == nil) {
            
            //show manual entry for location
            [countryAlert show];
            
        }else{
            
            //if location is found in image
            [self lookUpLocationWithCLLocation:location];
        }
        
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
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        inProgress = YES;
        [self.tableView reloadData];
    }];
    
}


-(void)setUpAlertForLocation{
    
    countryAlert = [[UIAlertView alloc] initWithTitle:@"Location" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    
    countryAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [countryAlert textFieldAtIndex:0].placeholder = @"Country";
    [countryAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeYes;
    [countryAlert textFieldAtIndex:1].autocorrectionType = UITextAutocorrectionTypeYes;
    [countryAlert textFieldAtIndex:1].placeholder = @"City";
    [countryAlert textFieldAtIndex:1].secureTextEntry = NO;

}

-(void)lookUpLocationWithCLLocation:(CLLocation *)loc{
    
    if (appDelegate.internetActive && mVc.locationAvail) {
        
        NSBlockOperation *searchLocationForImage = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.coder reverseGeocodeLocation:loc
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             if(!error){

                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 
                                 [self.savedLocations addObject:placemark];
                                 
                                 currentCountry = placemark.country;
                                 currentCity = placemark.locality;
                                 
                                 if (currentCity == nil) {
                                     currentCity = placemark.administrativeArea;
                                 }
                                 
                                 displayCountry = currentCountry;
                                 displayCity = currentCity;
                                 keyCountry = [[currentCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                 keyCity = [[currentCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                 
                                 self.countries = [pre setUpTableValuesForDictionary:self.countries countryName:keyCountry withCountryDisplay:displayCountry cityName:keyCity withCityDisplay:displayCity imgName:self.imgFileName andImage:img];
                                 [pre reinitializeCountries:self.countries];
                                 self.countryNames = pre.sortedCountryNames;
                                 self.cityNames = pre.sortedCityNames;
                                 [self.tableView reloadData];
                                 
                                 NSBlockOperation *insertIntoDB = [NSBlockOperation blockOperationWithBlock:^{
                                     [dbh insertMapLocationForCountry:displayCountry andCity:displayCity withLatitude:loc.coordinate.latitude andLongitude:loc.coordinate.longitude];
                                 }];
                                 
                                 [theQueue addOperation:insertIntoDB];
                                 
                             } else {
                                 NSLog(@"%@",[error description]);
                             }
                         }];
        }];
        
        [theQueue addOperation:searchLocationForImage];
        
    }else{
        
        [countryAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        currentCountry = [alertView textFieldAtIndex:0].text;
        currentCity = [alertView textFieldAtIndex:1].text;
        
    }else{
        
        if (inProgress) {
            inProgress = NO;
            [self.tableView reloadData];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[countryAlert textFieldAtIndex:0].text length] > 0 && [[countryAlert textFieldAtIndex:1].text length] > 0)
        {
            NSString *place = [NSString stringWithFormat:@"%@ %@",currentCity, currentCountry];
            
            if (appDelegate.internetActive && mVc.locationAvail) {
                
               NSBlockOperation *searchLocationForImage = [NSBlockOperation blockOperationWithBlock:^{
                [self.coder geocodeAddressString:place
                               completionHandler:^(NSArray *placemarks, NSError *error) {
                                   if(!error){
                                       
                                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                       [self.savedLocations addObject:placemark];
                                       displayCountry = placemark.country;
                                       displayCity = placemark.locality;
                                       
                                       if (displayCity == nil) {
                                           displayCity = placemark.administrativeArea;
                                       }
                                       
                                       keyCountry = [[displayCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                       keyCity = [[displayCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                       
                                        self.countries = [pre setUpTableValuesForDictionary:self.countries countryName:keyCountry withCountryDisplay:displayCountry cityName:keyCity withCityDisplay:displayCity imgName:self.imgFileName andImage:img];
                                       
                                        [pre reinitializeCountries:self.countries];
                                        self.countryNames = pre.sortedCountryNames;
                                        self.cityNames = pre.sortedCityNames;
                                       inProgress = NO;
                                        [self.tableView reloadData];

                                       NSBlockOperation *insertIntoDB = [NSBlockOperation blockOperationWithBlock:^{
                                           [dbh insertMapLocationForCountry:displayCountry andCity:displayCity withLatitude:placemark.location.coordinate.latitude andLongitude:placemark.location.coordinate.longitude];
                                           
                                       }];
                                       
                                       [theQueue addOperation:insertIntoDB];

                                   } else {
                                       
                                       NSLog(@"%@",[error description]);
                                       countryAlert.message = @"Invalid location please re-enter location";
                                       [countryAlert show];
                                       
                                   }
                               }];
               }];
                

                [theQueue addOperation:searchLocationForImage];
            
            }else{
            
                self.imgFileName = [NSString stringWithFormat:@"%@",keyCity];
                displayCountry = [currentCountry capitalizedString];
                displayCity = [currentCity capitalizedString];
                keyCountry = [[displayCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                keyCity = [[displayCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                self.countries = [pre setUpTableValuesForDictionary:self.countries countryName:keyCountry withCountryDisplay:displayCountry cityName:keyCity withCityDisplay:displayCity imgName:self.imgFileName andImage:img];
                [pre reinitializeCountries:self.countries];
                self.countryNames = pre.sortedCountryNames;
                self.cityNames = pre.sortedCityNames;
                inProgress = NO;
                [self.tableView reloadData];
                
                NSBlockOperation *insertIntoDB = [NSBlockOperation blockOperationWithBlock:^{
                    [dbh insertMapLocationForCountry:displayCountry andCity:displayCity withLatitude:0 andLongitude:0];
                }];
                
                [theQueue addOperation:insertIntoDB];
            }
            
        }else{
            
            countryAlert.message = @"Please enter a location";
            [countryAlert show];
        }

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //number of sections depends on number of countries
    return self.countries.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //loop through countries to get each number of city count
    for (int i=0; i<self.countryNames.count; i++) {
        
        if (section == i) {
            
            NSDictionary *temp = [[NSDictionary alloc] initWithDictionary:[[self.countries objectForKey:[self.countryNames objectAtIndex:i]] objectForKey:@"cities"]];
            return temp.count;
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city" forIndexPath:indexPath];
    
    //temp array to add all cities in current country/section
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSString *city in [[self.countries objectForKey:[self.countryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"]) {
        
        [temp addObject:city];
    }
    
    //sort array
    NSArray *tempArray = [temp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(259, 12, 20, 20)];
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    //set label for each cell according to each section and row
    cell.textLabel.text = [[[[self.countries objectForKey:[self.countryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"] objectForKey:[tempArray objectAtIndex:indexPath.row]] objectForKey:@"name"];

    
    if (inProgress) {
        cell.accessoryView = progressView;
        [progressView startAnimating];
    }else{
        
        [progressView stopAnimating];
        cell.accessoryView = nil;
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HeitiTC" size:10]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:54.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor darkGrayColor]];
    [header.textLabel setFont:[UIFont fontWithName:@"HeitiTC-Medium" size:19]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //51 204 204
//    NSLog(@"%@",[self.countries objectForKey:[self.countryNames objectAtIndex:section]]);

    return [[self.countries objectForKey:[self.countryNames objectAtIndex:section]] objectForKey:@"name"];
}

-(void)setUpImage:(UIImage *)image andLocation:(CLLocation *)loc{

    if (appDelegate.internetActive && mVc.locationAvail) {
        
        NSBlockOperation *searchLocationForImage = [NSBlockOperation blockOperationWithBlock:^{
            
            [self.coder reverseGeocodeLocation:loc
                             completionHandler:^(NSArray *placemarks, NSError *error) {
                                 if(!error){
                                     
                                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                     
                                     [self.savedLocations addObject:placemark];
                                     
                                     currentCountry = placemark.country;
                                     currentCity = placemark.locality;
                                     
                                     if (currentCity == nil) {
                                         currentCity = placemark.administrativeArea;
                                     }
                                     
                                     displayCountry = currentCountry;
                                     displayCity = currentCity;
                                     
                                     keyCountry = [[currentCountry stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                     keyCity = [[currentCity stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                                     
                                     img = image;
                                     self.imgFileName = [NSString stringWithFormat:@"%@",keyCity];

                                     self.countries = [pre setUpTableValuesForDictionary:self.countries countryName:keyCountry withCountryDisplay:displayCountry cityName:keyCity withCityDisplay:displayCity imgName:self.imgFileName andImage:img];
                                     [pre reinitializeCountries:self.countries];
                                     self.countryNames = [pre.sortedCountryNames mutableCopy];
                                     self.cityNames = [pre.sortedCityNames mutableCopy];
                                     inProgress = NO;
                                     [self.tableView reloadData];
                                    
                                     NSBlockOperation *insertIntoDB = [NSBlockOperation blockOperationWithBlock:^{

                                         UIImageWriteToSavedPhotosAlbum(image,self,nil,nil);
                                         
                                         [dbh insertMapLocationForCountry:displayCountry andCity:displayCity withLatitude:placemark.location.coordinate.latitude andLongitude:placemark.location.coordinate.longitude];
                                     }];
                                     
                                     [theQueue addOperation:insertIntoDB];
                                     
                                 } else {
                                     NSLog(@"%@",[error description]);
                                 }
                             }];
    
        }];
        
        [theQueue addOperation:searchLocationForImage];
        
        
    }else{

        img = image;
        UIImageWriteToSavedPhotosAlbum(image,self,nil,nil);
        [countryAlert show];
        
    }
    
    self.cameraImage = nil;
    self.cameraLocation = nil;
    self.imgFileName = nil;
    
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
    
    selectedCountry = [self.countryNames objectAtIndex:indexPath.section];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSString *s in [[self.countries objectForKey:selectedCountry] objectForKey:@"cities"]) {
        
        [temp addObject:s];
    }
    
    //sort array
    NSArray *tempArray = [temp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    selectedCity = [[[self.countries objectForKey:[self.countryNames objectAtIndex:indexPath.section]] objectForKey:@"cities"] objectForKey:[tempArray objectAtIndex:indexPath.row]];
    
    AlbumViewController *aVc = segue.destinationViewController;
    
    aVc.country = [[self.countries objectForKey:selectedCountry] objectForKey:@"name"];
    aVc.city = selectedCity;
    
}

@end
