//
//  AlbumViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "AlbumHeaderCollectionReusableView.h"
#import "ScrollImagesViewController.h"
#import "DBHandler.h"
#import "Image.h"

@interface AlbumViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSMutableArray *arrayOfImages;
    UIImage *currentImage;
    int currentPath;
    BOOL isSelected;
    DBHandler *dbh;
    
}

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSDictionary *city;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *deleteToolbar;
- (IBAction)deleteItems:(id)sender;

- (IBAction)selectItems:(id)sender;
@end
