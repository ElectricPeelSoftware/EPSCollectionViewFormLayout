//
//  EPSCollectionViewFormLayout.h
//  EPSCollectionViewFormLayoutExample
//
//  Created by Peter Stuart on 2/17/14.
//  Copyright (c) 2014 Electric Peel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPSCollectionViewFormLayoutDelegate <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout relativeWidthOfItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface EPSCollectionViewFormLayout : UICollectionViewLayout

@property (nonatomic) CGFloat cellSpacing;

@end
