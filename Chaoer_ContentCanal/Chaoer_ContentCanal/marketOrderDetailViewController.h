//
//  marketOrderDetailViewController.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface marketOrderDetailViewController : BaseVC

@property (strong,nonatomic) GShopOrder *mBaseOrder;

/**
 *  店铺id
 */
@property (nonatomic,assign) int mShopId;
/**
 *  订单id
 */
@property (nonatomic,assign) int mOrderId;

@end
