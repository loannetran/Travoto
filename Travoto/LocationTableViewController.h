//
//  LocationTableViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import "AlbumViewController.h"

@interface LocationTableViewController : UITableViewController <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableDictionary *countries;

- (IBAction)addPhotos:(id)sender;

@end
