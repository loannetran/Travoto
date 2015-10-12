//
//  AlbumViewController.m
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBarController.tabBar setHidden:YES];
    dbh = [[DBHandler alloc] init];
    
//    NSLog(@"%@",self.country);
//    NSLog(@"%@",self.city);
//    

//    NSLog(@"%f",self.enlargeView.frame.origin.y);

    [self setTitle:self.country];

//    [self.cityLbl setText:[self.city objectForKey:@"name"]];
}

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


- (IBAction)deleteItems:(id)sender {
    
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Items will be deleted, this action cannot be undone" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *del = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSMutableArray *deleteCells = [[NSMutableArray alloc] init];
        
        for (UICollectionViewCell *cell in self.imageCollectionView.visibleCells) {
            if (cell.alpha == 1) {
                NSIndexPath *indexPath = [self.imageCollectionView indexPathForCell:cell];
                [deleteCells addObject:indexPath];
                
            }
        }
        
        NSArray *temp = [dbh fetchAllItemsFromEntityNamed:@"Image"];
        NSMutableArray *deleteImageNames = [[NSMutableArray alloc] init];
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSIndexPath *itemPath  in deleteCells) {
            [indexSet addIndex:itemPath.row];
            NSData *newImg = UIImagePNGRepresentation([arrayOfImages objectAtIndex:itemPath.row]);
            
            BOOL imgExists = NO;
            NSString *imgName;
            
            for (int i = 0; i<temp.count; i++) {
                
                Image *img = [temp objectAtIndex:i];
                
                NSData *oldImg = UIImagePNGRepresentation(img.image);
                
                if ([newImg isEqual:oldImg]) {
                    
                    imgName = img.imageName;
                    [deleteImageNames addObject:imgName];
                    break;
                    
                }else{
                    imgExists = NO;
                }
                
            }
            
        }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            for (NSString *name in deleteImageNames) {
                [dbh deleteObjectIn:@"Image" whereAttribute:@"imageName" isEqualTo:name];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [arrayOfImages removeObjectsAtIndexes:indexSet];
                [self.imageCollectionView deleteItemsAtIndexPaths:deleteCells];
                
                isSelected = NO;
                self.selectBtn.title = @"Select";
                for (UICollectionViewCell *cell in self.imageCollectionView.visibleCells) {
                    cell.alpha = 1;
                }
                [self.deleteToolbar setHidden:YES];
                
            });
        });

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [deleteAlert addAction:del];
    [deleteAlert addAction:cancel];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

- (IBAction)selectItems:(id)sender {
    
    if (isSelected) {
        isSelected = NO;
        self.selectBtn.title = @"Select";
        for (UICollectionViewCell *cell in self.imageCollectionView.visibleCells) {
            cell.alpha = 1;
        }
        [self.deleteToolbar setHidden:YES];
    }else{
        isSelected = YES;
        for (UICollectionViewCell *cell in self.imageCollectionView.visibleCells) {
            cell.alpha = 0.5;
        }
        
        self.selectBtn.title = @"Cancel";
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!isSelected) {
        return YES;
    }else{
        NSLog(@"%@", indexPath);
        [self.deleteToolbar setHidden:NO];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.alpha == 0.5) {
            cell.alpha = 1;
        }else{
            [cell setAlpha:0.5];
        }
        
        return NO;
    }
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
