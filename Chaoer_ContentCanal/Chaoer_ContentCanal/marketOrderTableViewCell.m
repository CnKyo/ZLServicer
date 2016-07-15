//
//  marketOrderTableViewCell.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "marketOrderTableViewCell.h"

@implementation marketOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.mLeftBtn addTarget:self action:@selector(mLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mRightBtn addTarget:self action:@selector(mRightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mLeftBtn.layer.masksToBounds = self.mRightBtn.layer.masksToBounds = YES;
    self.mLeftBtn.layer.cornerRadius = self.mRightBtn.layer.cornerRadius = 3;
    self.mLeftBtn.layer.borderColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00].CGColor;
    self.mRightBtn.layer.borderColor = [UIColor colorWithRed:1.00 green:0.13 blue:0.13 alpha:1.00].CGColor;
    
    self.mLeftBtn.layer.borderWidth = self.mRightBtn.layer.borderWidth = 0.5;
    
    
    
}

- (void)mLeftAction:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(cellWithLeftBtnClick:andOrderStatus:andIndexPath:)]) {
        [self.delegate cellWithLeftBtnClick:self andOrderStatus:self.mOrderStatus andIndexPath:self.mIndexPath];
    }
    
}

- (void)mRightAction:(UIButton *)sender{
    
    
    if ([self.delegate respondsToSelector:@selector(cellWithRightBtnClick:andOrderStatus:andIndexPath:)]) {
        [self.delegate cellWithRightBtnClick:self andOrderStatus:self.mOrderStatus andIndexPath:self.mIndexPath];
    }
    
}

@end