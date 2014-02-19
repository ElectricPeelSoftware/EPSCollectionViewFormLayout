//
//  EPSCollectionViewFormLayout.h
//  EPSCollectionViewFormLayoutExample
//
//  Created by Peter Stuart on 2/17/14.
//  Copyright (c) 2014 Electric Peel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPSCollectionViewFormLayoutDelegate <UICollectionViewDelegate>

/// @returns The height of the section (which appears as a row) corresponding to \c section.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForSectionAtIndex:(NSInteger)section;

/// Returns the width of the item at \c indexPath relative to the width of the collection view. For example, returning \c 0.5 will make the item at \c indexPath be half as wide as the collection view.
/// @note The widths for any section should add up to \c 1.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout relativeWidthOfItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface EPSCollectionViewFormLayout : UICollectionViewLayout

/// The spacing between the cells and sections (therefore the width of the lines between them). Defaults to \c 1.0.
@property (nonatomic) CGFloat cellSpacing;

@end
