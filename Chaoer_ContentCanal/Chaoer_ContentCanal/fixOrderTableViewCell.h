//
//  fixOrderTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark----cell 代理方法
/**
 *  cell 代理方法
 */
@protocol cellWithBtnActionDelegate <NSObject>

@optional
/**
 *  左边按钮的代理方法
 *
 *  @param mIndexPath 返回索引
 */
- (void)cellWithLeftBtnActionIndexPath:(NSIndexPath *)mIndexPath;
/**
 *  右边按钮的代理方法
 *
 *  @param mIndexPath 返回索引
 */
- (void)cellWithRightBtnActionIndexPath:(NSIndexPath *)mIndexPath;


@end

@interface fixOrderTableViewCell : UITableViewCell
/**
 *  服务名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mName;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *mOrderStatus;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;
/**
 *  顾客名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceAddress;
/**
 *  金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mMoney;
/**
 *  联系按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mConnectBtn;
/**
 *  导航按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mNavBtn;
/**
 *  索引
 */
@property (assign,nonatomic) NSIndexPath *mIndexPath;

@property (strong,nonatomic) id<cellWithBtnActionDelegate> delegate;

/**
 *  报修订单列表对象
 */
@property (strong,nonatomic) GFixOrderList *mItem;

@end
