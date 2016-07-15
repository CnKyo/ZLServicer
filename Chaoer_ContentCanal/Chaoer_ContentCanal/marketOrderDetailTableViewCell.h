//
//  marketOrderDetailTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface marketOrderDetailTableViewCell : UITableViewCell
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
/**
 *  子内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mSubContent;
/**
 *  数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mNum;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mPrice;

@end
