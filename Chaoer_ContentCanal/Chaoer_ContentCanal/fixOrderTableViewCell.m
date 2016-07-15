//
//  fixOrderTableViewCell.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "fixOrderTableViewCell.h"

@implementation fixOrderTableViewCell

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
    self.mConnectBtn.layer.masksToBounds = self.mNavBtn.layer.masksToBounds = YES;
    self.mConnectBtn.layer.cornerRadius = self.mNavBtn.layer.cornerRadius = 3;
    self.mNavBtn.layer.borderColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00].CGColor;
    self.mConnectBtn.layer.borderColor = [UIColor colorWithRed:1.00 green:0.13 blue:0.13 alpha:1.00].CGColor;
    
    self.mConnectBtn.layer.borderWidth = self.mNavBtn.layer.borderWidth = 0.5;
}
@end
