//
//  AlbumViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController (){
    
    NSArray *arrayOfImages;
    UIImage *currentImage;
    int currentPath;

}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBarController.tabBar setHidden:YES];
    
//    NSLog(@"%@",self.country);
//    NSLog(@"%@",self.city);
//    

//    NSLog(@"%f",self.enlargeView.frame.origin.y);

    [self setTitle:self.country];

//    [self.cityLbl setText:[self.city objectForKey:@"name"]];
}

//-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    currentImage = [arrayOfImages objectAtIndex:indexPath.row];;
    
    currentPath = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"slideshow" sender:self];
    
//    [self animateView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    arrayOfImages = [self.city objectForKey:@"images"];
    return arrayOfImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.photoImgView.image = [arrayOfImages objectAtIndex:indexPath.row];
    
    [cell.layer setBorderWidth:1];
    [cell.layer setBorderColor:[UIColor darkGrayColor].CGColor];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        AlbumHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cityHeader" forIndexPath:indexPath];

        [headerView.cityLbl setText:[self.city objectForKey:@"name"]];
        [headerView.cityLbl setShadowColor: [UIColor blackColor]];
        [headerView.cityLbl setShadowOffset: CGSizeMake(0, -1.0)];

        reusableview = headerView;
    }

    //if footer is used
//    if (kind == UICollectionElementKindSectionFooter) {
//    }
    
    return reusableview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     ScrollImagesViewController *sVc = segue.destinationViewController;
     
     sVc.imageArray = arrayOfImages;
     sVc.currentImage = currentPath+1;
     
 }


@end
