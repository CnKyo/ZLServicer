//
//  fixDetailTableViewCell.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "fixDetailTableViewCell.h"

@implementation fixDetailTableViewCell

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
    
    self.mNavBtn.layer.masksToBounds = self.mConnectBtn.layer.masksToBounds = YES;
    self.mNavBtn.layer.cornerRadius = self.mConnectBtn.layer.cornerRadius = 3;
    
    self.mNavBtn.layer.borderColor = self.mConnectBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.mConnectBtn.layer.borderWidth =  self.mNavBtn.layer.borderWidth = 0.5;
}

@end
