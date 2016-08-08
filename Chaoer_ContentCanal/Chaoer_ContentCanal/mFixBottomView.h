//
//  mFixBottomView.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark----底部view的代理方法
/**
 *  底部view的代理方法
 */
@protocol cellWithBottomViewBtnDelegate <NSObject>

@optional
/**
 *  拒绝接单按钮的代理
 */
- (void)cellWithCancelOrderBtnAction;
/**
 *  接受订单按钮的代理
 */
- (void)cellWithAcceptOrderBtnAction;


@end

@interface mFixBottomView : UIView
/**
 *  左边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mLeftBtn;
/**
 *  右边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mRightBtn;
/**
 *  接单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mMidBtn;


/**
 *  初始化方法
 *
 *  @return 返回view
 */
+ (mFixBottomView *)shareView;

@property (strong,nonatomic) id <cellWithBottomViewBtnDelegate>delegate;

@end
