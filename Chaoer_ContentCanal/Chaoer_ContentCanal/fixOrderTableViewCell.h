//
//  fixOrderTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

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


@end
