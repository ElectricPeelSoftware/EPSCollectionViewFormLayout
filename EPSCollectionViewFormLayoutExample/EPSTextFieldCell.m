//
//  EPSTextFieldCell.m
//  EPSCollectionViewFormLayoutExample
//
//  Created by Peter Stuart on 2/17/14.
//  Copyright (c) 2014 Electric Peel. All rights reserved.
//

#import "EPSTextFieldCell.h"

@interface EPSTextFieldCell ()

@property (readwrite, nonatomic) UITextField *textField;

@end

@implementation EPSTextFieldCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:textField];
        _textField = textField;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectInset(self.contentView.bounds, 10, 0);
}

@end
