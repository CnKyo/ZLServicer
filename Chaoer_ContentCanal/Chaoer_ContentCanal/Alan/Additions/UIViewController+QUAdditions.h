//
//  UIViewController+Additions.h
//  IFCClient
//
//  Created by Apple on 13-6-27.
//  Copyright (c) 2013年 麦瑞科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIViewController (QUAdditions)


+ (UIViewController*)topViewController;  //获取最外层rootvc的活动vc
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController; //获取对应rootvc的活动vc
+(UIViewController *)getCurrentRootViewController; //获取当前活动vc


@end



