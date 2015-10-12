//
//  ScrollImagesViewController.h
//  Travoto
//
//  Created by Loanne Tran on 9/13/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImagesViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, strong) UIImageView *imageView;
//
//- (void)centerScrollViewContents;
//- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
//- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) long currentImage;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

- (IBAction)goBack:(id)sender;
- (IBAction)deleteImage:(id)sender;

@end
