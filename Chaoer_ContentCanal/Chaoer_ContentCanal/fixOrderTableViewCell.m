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

- (void)setMItem:(GFixOrderList *)mItem{

    
    self.mOrderStatus.text = mItem.mOrderCode;
    self.mName.text = [NSString stringWithFormat:@"服务名称:%@", mItem.mServiceName.length>0 ? mItem.mServiceName : @"暂无"];
    self.mPhone.text = [NSString stringWithFormat:@"联系电话:%@", mItem.mPhone.length>0 ? mItem.mPhone : @"暂无"];
    self.mTime.text = [NSString stringWithFormat:@"预约时间:%@", mItem.mAddTime.length>0 ? mItem.mAddTime : @"暂无"];
    self.mMoney.text = [NSString stringWithFormat:@"订单金额:¥%.2f元",mItem.mPrice];
    
    self.mServiceName.text = [NSString stringWithFormat:@"顾客名称:%@",mItem.mUserName.length>0?mItem.mUserName : @"暂无"];
    
    self.mServiceAddress.text = [NSString stringWithFormat:@"%@",mItem.mAddress.length>0?mItem.mAddress : @"暂无"];

    
}

- (IBAction)mLeftBtnAction:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(cellWithLeftBtnActionIndexPath:)]) {
        [self.delegate cellWithLeftBtnActionIndexPath:self.mIndexPath];
    }
    
    
}

- (IBAction)mRightBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithRightBtnActionIndexPath:)]) {
        [self.delegate cellWithRightBtnActionIndexPath:self.mIndexPath];
    }
    
    
}


@end
