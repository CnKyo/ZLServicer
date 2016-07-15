//
//  mFixBottomView.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  初始化方法
 *
 *  @return 返回view
 */
+ (mFixBottomView *)shareView;

@end
