//
//  AVAndaJson.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataModel.h"
#import "AFNetworking.h"
#import "HDSingleton.h"

@class mBaseData;

@interface AVAndaJson : NSObject

HDSingletonH(HDNetworking) // 单例声明

/**
 *  可接受的响应内容类型
 */
@property (nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;

-(void)postUrl:(NSString *)URLString parameters:(id)parameters call:(void (^)( mJHBaseData* info))callback;



+ (NSString *)returnNowURL;

@end
