//
//  fixDetailTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark-----cell按钮的点击代理方法
/**
 *  cell按钮的点击代理方法
 */
@protocol cellWithDetailBtnActionDelegate<NSObject>

@optional
/**
 *  导航按钮方法
 */
- (void)cellWithNavBtnAction;
/**
 *  打电话按钮方法
 */
- (void)cellWithPhoneBtnAction;
/**
 *  查看图片方法
 */
- (void)cellWithImgBtnAction;
/**
 *  查看视频方法
 */
- (void)cellWithVideoBtnAction;


@end

@interface fixDetailTableViewCell : UITableViewCell
/**
 *  状态图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mStatusImg;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *mStatus;
/**
 *  服务名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mName;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *mOrderCode;
/**
 *  顾客名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
/**
 *  拨打按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mConnectBtn;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
/**
 *  导航按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mNavBtn;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UILabel *mNote;
/**
 *  金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mMoney;
/**
 *  保证金
 */
@property (weak, nonatomic) IBOutlet UILabel *mPromisPrice;
/**
 *  查看图片
 */
@property (weak, nonatomic) IBOutlet UIButton *mCheckImgBtn;
/**
 *  查看视频
 */
@property (weak, nonatomic) IBOutlet UIButton *mCheckVieoBtn;

@property (strong,nonatomic) id <cellWithDetailBtnActionDelegate>delegate;

@property (strong,nonatomic) GFixOrder *mOrderDetail;

@end
