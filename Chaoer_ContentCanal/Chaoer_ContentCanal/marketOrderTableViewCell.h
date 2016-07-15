//
//  marketOrderTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class marketOrderTableViewCell;

@protocol marketCellDelegate <NSObject>

@optional
/**
 *  左边按钮的代理方法
 *
 *  @param cell         cell
 *  @param mOrderStatus 状态
 *  @param IndexPath    索引
 */
- (void)cellWithLeftBtnClick:(marketOrderTableViewCell *)cell andOrderStatus:(int)mOrderStatus andIndexPath:(NSIndexPath *)IndexPath;
/**
 *  右边按钮的代理方法
 *
 *  @param cell         cell
 *  @param mOrderStatus 状态
 *  @param IndexPath    索引
 */
- (void)cellWithRightBtnClick:(marketOrderTableViewCell *)cell andOrderStatus:(int)mOrderStatus andIndexPath:(NSIndexPath *)IndexPath;

@end

@interface marketOrderTableViewCell : UITableViewCell
/**
 *  店铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mStoreName;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *mStatus;
/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mProductImg;
/**
 *  商品内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
/**
 *  商品子内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mSubContent;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
/**
 *  右边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mRightBtn;
/**
 *  左边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mLeftBtn;
/**
 *  索引
 */
@property (strong,nonatomic) NSIndexPath *mIndexPath;
/**
 *  状态
 */
@property (assign,nonatomic) int mOrderStatus;
/**
 *  代理方法
 */
@property (strong,nonatomic) id <marketCellDelegate> delegate;

@end
