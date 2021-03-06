//
//  EPSCollectionViewFormLayout.m
//  EPSCollectionViewFormLayoutExample
//
//  Created by Peter Stuart on 2/17/14.
//  Copyright (c) 2014 Electric Peel. All rights reserved.
//

#import "EPSCollectionViewFormLayout.h"

NSString * const EPSCollectionViewFormLayoutDecorationViewKind = @"EPSCollectionViewFormLayoutDecorationViewKind";

@interface EPSCollectionViewFormLayoutBackgroundView : UICollectionReusableView

@end

@implementation EPSCollectionViewFormLayoutBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return self;
}

@end

@interface EPSCollectionViewFormLayout ()

@property (readonly) id <EPSCollectionViewFormLayoutDelegate> delegate;

@end

@implementation EPSCollectionViewFormLayout

#pragma mark - Overrides

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    _cellSpacing = 1.0;
    
    [self registerClass:[EPSCollectionViewFormLayoutBackgroundView class] forDecorationViewOfKind:EPSCollectionViewFormLayoutDecorationViewKind];
    
    return self;
}

- (CGSize)collectionViewContentSize {
    NSInteger lastSection = self.collectionView.numberOfSections - 1;
    CGFloat yOriginOfLastSection = [self yOriginForSection:lastSection];
    CGFloat heightOfLastSection = [self heightForSection:lastSection];
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), yOriginOfLastSection + heightOfLastSection + self.cellSpacing);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray new];
    
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *layoutAttribute = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, layoutAttribute.frame)) {
                [layoutAttributes addObject:layoutAttribute];
            }
        }
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        if (attributes != nil && CGRectIntersectsRect(rect, attributes.frame)) {
            [layoutAttributes addObject:attributes];
        }
        
        UICollectionViewLayoutAttributes *decorationAttribute = [self layoutAttributesForDecorationViewOfKind:EPSCollectionViewFormLayoutDecorationViewKind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (CGRectIntersectsRect(rect, decorationAttribute.frame)) {
            [layoutAttributes addObject:decorationAttribute];
        }
    }
    
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat xOrigin = [self xOriginForItemAtIndexPath:indexPath];
    CGFloat width = [self widthForItemAtIndexPath:indexPath];
    
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        width = [self collectionViewContentSize].width - xOrigin;
    }
    
    attributes.frame = CGRectMake(xOrigin, [self yOriginForSection:indexPath.section], width, [self heightForSection:indexPath.section]);
    attributes.zIndex = 1;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:EPSCollectionViewFormLayoutDecorationViewKind withIndexPath:indexPath];
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = [self yOriginForSection:indexPath.section] - self.cellSpacing;
    frame.size.width = CGRectGetWidth(self.collectionView.frame);
    frame.size.height = [self heightForSection:indexPath.section] + 2 * self.cellSpacing;
    
    attributes.frame = frame;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForFooterInSection:)] == NO) return nil;
    
    CGFloat height = [self.delegate collectionView:self.collectionView layout:self referenceHeightForFooterInSection:indexPath.section];
    if (height == 0) return nil;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = [self yOriginForSection:indexPath.section] + [self heightForSection:indexPath.section];
    frame.size.width = CGRectGetWidth(self.collectionView.frame);
    frame.size.height = height;
    
    attributes.frame = frame;
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark -

- (CGFloat)yOriginForSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    NSInteger previousSection = section - 1;
    CGFloat yOriginOfPreviousSection = [self yOriginForSection:previousSection];
    CGFloat heightOfPreviousSection = [self heightForSection:previousSection];
    CGFloat spacingBelowPreviousSection = [self spacingBelowSection:previousSection];
    
    CGFloat heightOfFooter = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForFooterInSection:)] && section > 0) {
        heightOfFooter = [self.delegate collectionView:self.collectionView layout:self referenceHeightForFooterInSection:section - 1];
    }
    return yOriginOfPreviousSection + heightOfPreviousSection + spacingBelowPreviousSection + heightOfFooter + self.cellSpacing;
}

- (CGFloat)heightForSection:(NSInteger)section {
    return [self.delegate collectionView:self.collectionView layout:self heightForSectionAtIndex:section];
}

- (CGFloat)spacingBelowSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:spacingBelowSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self spacingBelowSection:section];
    }
    else {
        return 0;
    }
}

- (CGFloat)xOriginForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) return 0;
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGFloat xOriginOfPreviousItem = [self xOriginForItemAtIndexPath:previousIndexPath];
    CGFloat widthOfPreviousItem = [self widthForItemAtIndexPath:previousIndexPath];
    
    return xOriginOfPreviousItem + widthOfPreviousItem + self.cellSpacing;
}

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalWidth = CGRectGetWidth(self.collectionView.frame) - ([self.collectionView numberOfItemsInSection:indexPath.section] - 1) * self.cellSpacing;
    CGFloat width = floorf(totalWidth * [self.delegate collectionView:self.collectionView layout:self relativeWidthOfItemAtIndexPath:indexPath]);
    return width;
}

- (id <EPSCollectionViewFormLayoutDelegate>)delegate {
    return (id <EPSCollectionViewFormLayoutDelegate>)self.collectionView.delegate;
}

@end
