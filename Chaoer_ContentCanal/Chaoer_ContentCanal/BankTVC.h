//
//  BankTVC.h
//  Chaoer_ContentCanal
//
//  Created by 瞿伦平 on 16/8/26.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface BankTVC : BaseVC
@property (nonatomic, copy) void (^chooseCallBack)(BankObject* item);

@end
