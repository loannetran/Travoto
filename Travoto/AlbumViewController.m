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
}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.country);
    NSLog(@"%@",self.city);
    
    [self setTitle:self.country];
//    [self.cityLbl setText:[self.city objectForKey:@"name"]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    arrayOfImages = [self.city objectForKey:@"images"];
    
    return arrayOfImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    for (int i=0; i<arrayOfImages.count; i++) {
        
        if (indexPath.row == i) {
            cell.photoImgView.image = [arrayOfImages objectAtIndex:i];
        
        }
        
    }
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
