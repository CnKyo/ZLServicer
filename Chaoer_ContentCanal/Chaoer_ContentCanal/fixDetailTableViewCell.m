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

- (void)setMOrderDetail:(GFixOrder *)mOrderDetail{

    self.mName.text = [NSString stringWithFormat:@"服务名称:%@", mOrderDetail.mClassificationName.length>0 ? mOrderDetail.mClassificationName : @"暂无"];
    self.mOrderCode.text = [NSString stringWithFormat:@"订单编号:%@", mOrderDetail.mOrderCode.length>0 ? mOrderDetail.mOrderCode : @"暂无"];
    self.mServiceName.text = [NSString stringWithFormat:@"顾客名称:%@", mOrderDetail.mMerchantName.length>0 ? mOrderDetail.mMerchantName : @"暂无"];
    self.mTime.text = [NSString stringWithFormat:@"预约时间:%@",mOrderDetail.mOrderServiceTime.length>0 ? mOrderDetail.mOrderServiceTime : @"暂无"];
    self.mPhone.text = [NSString stringWithFormat:@"联系电话:%@", mOrderDetail.mPhone.length>0 ? mOrderDetail.mPhone : @"暂无"];
    self.mAddress.text = [NSString stringWithFormat:@"%@", mOrderDetail.mAddress.length>0 ? mOrderDetail.mAddress : @"暂无"];
    self.mNote.text = [NSString stringWithFormat:@"%@", mOrderDetail.mNote.length>0 ? mOrderDetail.mNote : @"暂无"];
    self.mMoney.text = [NSString stringWithFormat:@"维修金额:￥%.2f", mOrderDetail.mOrderPrice];
    self.mPromisPrice.text = [NSString stringWithFormat:@"预计金额:￥%.2f", mOrderDetail.mEstimatedPrice];
    
    UIImage *mStateImg = nil;
    NSString *mSS = nil;
    if (mOrderDetail.mStatus == 4) {
        mStateImg = [UIImage imageNamed:@"status_wait"];
        mSS = @"等待接单";
    }else if (mOrderDetail.mStatus == 8){
        mStateImg = [UIImage imageNamed:@"status_ing"];
        mSS = @"服务进行中";

    }else{
        mStateImg = [UIImage imageNamed:@"status_finish"];
        mSS = @"完成服务";

    }
    
    self.mStatusImg.image = mStateImg;
    
    self.mStatus.text = mSS;
    
    UIImageView *mFiximg = [UIImageView new];

    if (mOrderDetail.mOrderImage.length <= 0) {
        mFiximg.image = [UIImage imageNamed:@"fix_noImage"];
    }else{
        [mFiximg sd_setImageWithURL:[NSURL URLWithString:mOrderDetail.mOrderImage] placeholderImage:[UIImage imageNamed:@"fix_havaImage"]];
    }
    
    [self.mCheckImgBtn setBackgroundImage:mFiximg.image forState:0];
    
    UIImage *mVideo = nil;
    if (mOrderDetail.mVideoUrl.length == 0) {
        mVideo = [UIImage imageNamed:@"fix_noVedio"];
    }else{
        mVideo = [UIImage imageNamed:@"fix_haveVedio"];
    }
    
    [self.mCheckVieoBtn setBackgroundImage:mVideo forState:0];
    
    
}


- (IBAction)mPhoneBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithPhoneBtnAction)]) {
        [self.delegate cellWithPhoneBtnAction];
    }
    
    
}

- (IBAction)mNavBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithNavBtnAction)]) {
        [self.delegate cellWithNavBtnAction];
    }
    
    
}

- (IBAction)mCheckImgVBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithImgBtnAction)]) {
        [self.delegate cellWithImgBtnAction];
    }
    
    
}

- (IBAction)mCheckVideoBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithVideoBtnAction)]) {
        [self.delegate cellWithVideoBtnAction];
    }
    
}


@end
