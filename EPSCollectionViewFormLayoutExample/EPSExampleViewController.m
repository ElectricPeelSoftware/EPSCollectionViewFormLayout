//
//  EPSExampleViewController.m
//  EPSCollectionViewFormLayoutExample
//
//  Created by Peter Stuart on 2/17/14.
//  Copyright (c) 2014 Electric Peel. All rights reserved.
//

#import "EPSExampleViewController.h"

#import "EPSCollectionViewFormLayout.h"
#import "EPSTextFieldCell.h"

NSString * const EPSExampleViewControllerCellIdentifier = @"EPSExampleViewControllerCellIdentifier";

@interface EPSExampleViewController () <EPSCollectionViewFormLayoutDelegate>

@end

@implementation EPSExampleViewController

- (id)init {
    EPSCollectionViewFormLayout *layout = [[EPSCollectionViewFormLayout alloc] init];
    
    self = [super initWithCollectionViewLayout:layout];
    if (self == nil) return nil;
    
    self.title = @"Form Layout";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.collectionView registerClass:[EPSTextFieldCell class] forCellWithReuseIdentifier:EPSExampleViewControllerCellIdentifier];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *items = @[ @1, @2, @2 ];
    
    return [items[section] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EPSTextFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EPSExampleViewControllerCellIdentifier forIndexPath:indexPath];
    
    NSArray *placeholders = @[ @[ @"Address" ],
                               @[ @"State", @"Zip Code" ],
                               @[ @"Country", @"Phone" ] ];
    
    cell.textField.placeholder = placeholders[indexPath.section][indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EPSTextFieldCell *cell = (EPSTextFieldCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - EPSCollectionViewFormLayoutDelegate Methods

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForSectionAtIndex:(NSInteger)section {
    return 44;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout relativeWidthOfItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *widths = @[ @[ @1 ],
                         @[ @0.5, @0.5 ],
                         @[ @0.3, @0.7 ] ];
    
    return [widths[indexPath.section][indexPath.item] doubleValue];
}

@end
