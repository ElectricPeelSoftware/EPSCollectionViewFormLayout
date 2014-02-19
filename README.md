# EPSCollectionViewFormLayout

`EPSCollectionViewFormLayout` is a subclass of `UICollectionViewLayout` that makes it easy to layout forms, like login and address forms, in a collection view.

![Address Example](https://raw.github.com/ElectricPeelSoftware/EPSCollectionViewFormLayout/master/Assets/AddressExample.png)

For an example of how to use `EPSCollectionViewFormLayout`, see the [example project](https://github.com/ElectricPeelSoftware/EPSCollectionViewFormLayout/tree/master/Example).

When using `EPSCollectionViewFormLayout`, each section in the collection view is laid out in one row. Your collection view’s `delegate` must implement the two methods in the `EPSCollectionViewFormLayoutDelegate` protocol:

```objective-c
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout relativeWidthOfItemAtIndexPath:(NSIndexPath *)indexPath;
```

The widths returned in `collectionView:layout:relativeWidthOfItemAtIndexPath:` are relative to the width of the collection view, so returning `0.5` would make the cell at that `indexPath` be half the width of the collection view.