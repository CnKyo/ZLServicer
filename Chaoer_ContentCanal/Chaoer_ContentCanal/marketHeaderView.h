//
//  marketHeaderView.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  底部按钮的代理方法
 */
@protocol cellWithBottomBtnActionDelegate <NSObject>

@optional
/**
 *  左边按钮的代理方法
 */
- (void)cellWithBottomLeftBtnAction;
/**
 *  右边按钮的代理方法
 */
- (void)cellWithBottomRightBtnAction;
/**
 *  取消订单代理方法
 */
- (void)cellWithCancelOrderAction;
/**
 *  确认订单代理方法
 */
- (void)cellWithComfirmOrderAction;
/**
 *  完成订单代理方法
 */
- (void)cellWithFinishOrderAction;

@end

@interface marketHeaderView : UIView

#pragma mark----headerView
/**
 *  状态图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mStatusImg;
/**
 *  客户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
/**
 *  店铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mStoreName;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *mStatus;
/**
 *  初始化方法
 *
 *  @return 返回view
 */
+ (marketHeaderView *)shareHeaderView;

#pragma mark----footerView
/**
 *  配送费
 */
@property (weak, nonatomic) IBOutlet UILabel *mSendPrice;
/**
 *  总金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mTotalPrice;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UILabel *mNote;
/**
 *  导航
 */
@property (weak, nonatomic) IBOutlet UIButton *mNavBtn;
/**
 *  联系顾客
 */
@property (weak, nonatomic) IBOutlet UIButton *mConnectBtn;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *mOrderCode;
/**
 *  服务时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;
/**
 *  初始化方法
 *
 *  @return 返回view
 */
+ (marketHeaderView *)shareFooterView;
#pragma mark----bottomView
/**
 *  左边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mLeftBtn;
/**
 *  右边的按钮   
 */
@property (weak, nonatomic) IBOutlet UIButton *mRightBtn;
/**
 *  完成服务
 */
@property (weak, nonatomic) IBOutlet UIButton *mFinishBtn;


/**
 *  初始化方法
 *
 *  @return 返回view
 */
+ (marketHeaderView *)shareBottomView;

@property (strong,nonatomic) id <cellWithBottomBtnActionDelegate> delegate;

@end
