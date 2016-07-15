//
//  mMyTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mMyTableViewCell : UITableViewCell
#pragma mark ---- cell样式1
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mLogo;
/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mName;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
#pragma mark ---- cell样式1
/**
 *  气泡
 */
@property (weak, nonatomic) IBOutlet UILabel *mBadge;


@end
