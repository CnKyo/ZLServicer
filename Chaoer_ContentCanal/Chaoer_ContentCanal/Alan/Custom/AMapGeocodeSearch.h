//
//  AMapGeocodeSearch.h
//  Chaoer_ContentCanal
//
//  Created by 瞿伦平 on 16/9/13.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AMapGeocodeSearch : NSObject
+ (instancetype)sharedClient;

-(void)searchAddress:(NSString *)address;

@end
