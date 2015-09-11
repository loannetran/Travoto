//
//  AlbumViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSDictionary *city;

@end
