//
//  AMapGeocodeSearch.m
//  Chaoer_ContentCanal
//
//  Created by 瞿伦平 on 16/9/13.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "AMapGeocodeSearch.h"
#import "SVProgressHUD.h"
#import <MapKit/MapKit.h>

@interface AMapGeocodeSearch ()<AMapSearchDelegate>
@property(nonatomic,strong) AMapSearchAPI *searchAPI;
@end



@implementation AMapGeocodeSearch

+ (instancetype)sharedClient {
    static AMapGeocodeSearch *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AMapGeocodeSearch alloc] init];
    });
    return _sharedClient;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.searchAPI = [[AMapSearchAPI alloc] init];
        self.searchAPI.delegate = self;
    }
    return self;
}


-(void)searchAddress:(NSString *)address
{
    if (address.length > 1) {
        //NSString *address = @"重庆重庆渝中区万科锦城1栋-1单元1-1";
        AMapGeocodeSearchRequest *searchReq = [[AMapGeocodeSearchRequest alloc] init];
        searchReq.address = address;
        [self.searchAPI AMapGeocodeSearch:searchReq];
        
        [SVProgressHUD showWithStatus:@"地址解析中..."];
    } else
        [SVProgressHUD showErrorWithStatus:@"导航地址有误！请查证！"];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    [SVProgressHUD dismiss];
    
    if (response.geocodes.count > 0) {
        AMapGeocode *geo = [response.geocodes objectAtIndex:0];
        AMapGeoPoint *location = geo.location;
        
        NSString *strLat=[NSString stringWithFormat:@"%f",location.latitude];
        NSString *strLong=[NSString stringWithFormat:@"%f",location.longitude];
        
        
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=0", @"gotoMap",[HTTPrequest getAppName],strLat, strLong] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //跳转到高德地图
        NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=0",@"gotoMap",[HTTPrequest getAppName],strLat, strLong];
        
        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]] )
        {//
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        else
        {//ioS map
            
            CLLocationCoordinate2D to;
            to.latitude =  [[NSString stringWithFormat:@"%@",strLat] floatValue];
            to.longitude =  [[NSString stringWithFormat:@"%@",strLong] floatValue];
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
            toLocation.name = geo.formattedAddress;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
        

        
    } else
        [SVProgressHUD showErrorWithStatus:@"该城市不存在或者搜索有误"];
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"导航地址解析错误"];
    NSLog(@"%@", error);
}



@end
