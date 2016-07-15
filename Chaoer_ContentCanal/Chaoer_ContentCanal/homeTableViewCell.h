//
//  homeTableViewCell.h
//  Chaoer_ContentCanal
//
//  Created by 王钶 on 16/3/10.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeTableViewCell : UITableViewCell
/**
 *  图片
 */
@property (strong, nonatomic) IBOutlet UIImageView *mImg;
/**
 *  标题
 */
@property (strong, nonatomic) IBOutlet UILabel *mTitle;

@property (weak, nonatomic) IBOutlet UIView *mBgk;

@end
