//
//  mMyHeaderView.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/12.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mMyHeaderView : UIView
/**
 *  背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *mBgk;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *mHeader;
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *mName;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
/**
 *  账户
 */
@property (weak, nonatomic) IBOutlet UILabel *mMoney;
/**
 *  提现
 */
@property (weak, nonatomic) IBOutlet UIButton *mCashBtn;
/**
 *  头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mHeaderBtn;
/**
 *  初始化方法
 *
 *  @return 返回view
 */
+ (mMyHeaderView *)shareView;

@end
