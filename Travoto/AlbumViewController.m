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
    EnlargeImageView *enlargeImg;

}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBarController.tabBar setHidden:YES];
    [self setUpDisplayView];
    
    NSLog(@"%@",self.country);
    NSLog(@"%@",self.city);
    

//    NSLog(@"%f",self.enlargeView.frame.origin.y);

    [self setTitle:self.country];

//    [self.cityLbl setText:[self.city objectForKey:@"name"]];
}

-(void)setUpDisplayView{
    
    enlargeImg = [[EnlargeImageView alloc] init];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    currentImage = [arrayOfImages objectAtIndex:indexPath.row];
    
    [self animateView];
    
}

-(void) animateView{

    enlargeImg.bigImgView.image = currentImage;
    
    [UIView animateWithDuration:0.5
            animations:^{
                            enlargeImg.frame = CGRectMake(15, 90, 290, 450);
                            enlargeImg.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:0.6];
                            [enlargeImg.layer setCornerRadius:10];
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5
                        animations:^{
                            [enlargeImg.bigImgView setAlpha:1];
                            [enlargeImg addSubview:enlargeImg.bigImgView];
                            [enlargeImg addSubview:enlargeImg.closeBtn];
                            [enlargeImg addSubview:enlargeImg.commentView];
                            [enlargeImg addSubview:enlargeImg.commentTxt];
                        }];
                
            }];
    
    [enlargeImg.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enlargeImg];

}

-(void)closeView{
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [enlargeImg.bigImgView setAlpha:0];
                         [enlargeImg.closeBtn removeFromSuperview];
                         [enlargeImg.commentTxt removeFromSuperview];
                         [enlargeImg.commentView removeFromSuperview];

                         enlargeImg.frame = CGRectMake(15, 90, 0, 0);
    }];

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
