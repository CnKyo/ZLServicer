//
//  mmgTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mmgTableViewCell : UITableViewCell
/**
 *  logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *mLogo;
/**
 *  消息点
 */
@property (weak, nonatomic) IBOutlet UIImageView *mPoint;
/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mName;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;

@property (strong,nonatomic) GMsgObj *mMsg;
@end
