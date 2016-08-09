//
//  marketOrderDetailViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "marketOrderDetailViewController.h"
#import "marketHeaderView.h"
#import "marketOrderDetailTableViewCell.h"
#import <MapKit/MapKit.h>

@interface marketOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,cellWithBottomBtnActionDelegate>

@end

@implementation marketOrderDetailViewController
{
    
    marketHeaderView *mHeaderView;
    marketHeaderView *mFooterView;
    marketHeaderView *mBottomView;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"购物订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-124) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"marketOrderDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    mHeaderView = [marketHeaderView shareHeaderView];
    mHeaderView.frame = CGRectMake(0, 0, DEVICE_Width, 190);
    [self.tableView setTableHeaderView:mHeaderView];
    
    mFooterView = [marketHeaderView shareFooterView];
    mFooterView.frame = CGRectMake(0, 0, DEVICE_Width, 250);
    mFooterView.delegate = self;
    [self.tableView setTableFooterView:mFooterView];
    
    mBottomView = [marketHeaderView shareBottomView];
    mBottomView.delegate = self;
    [self.view addSubview:mBottomView];
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(@0);
        make.height.offset(@60);
        make.width.offset(DEVICE_Width);
    }];
    
    
}
- (void)headerBeganRefresh{
    
    [[mUserInfo backNowUser] getShoppingOrderDetail:self.mOrderId andShopId:self.mShopId block:^(mBaseData *resb, GShopOrder *mShopOrder) {
        
        [self headerEndRefresh];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            self.mBaseOrder = mShopOrder;
            [self upDAtePage];
            [self.tableView reloadData];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self addEmptyView:nil];
            [self popViewController];
        }
    }];
    
}

- (void)upDAtePage{

    mHeaderView.mServiceName.text = [NSString stringWithFormat:@"收货人:%@",self.mBaseOrder.mUserName];
    mHeaderView.mPhone.text = self.mBaseOrder.mPhone;
    mHeaderView.mAddress.text = [NSString stringWithFormat:@"收货地址:%@",self.mBaseOrder.mDistributionAddress];
    mHeaderView.mStoreName.text = self.mBaseOrder.mShopName;
    
    
    NSString *mSS = nil;
    UIImage *mTT = nil;
    
    if (self.mBaseOrder.mState == 12) {
        mSS = @"进行中";
        mTT = [UIImage imageNamed:@"status_ing"];
        [mBottomView.mFinishBtn setTitle:@"确认完成" forState:0];

    }else if (self.mBaseOrder.mState == 13){
        mSS = @"服务已完成";
        mTT = [UIImage imageNamed:@"status_finish"];
        [mBottomView.mFinishBtn setTitle:mSS forState:0];
        [mBottomView.mFinishBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        mSS = @"取消订单";
        mTT = [UIImage imageNamed:@"status_finish"];
        [mBottomView.mFinishBtn setTitle:mSS forState:0];
        [mBottomView.mFinishBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    mHeaderView.mStatusImg.image = mTT;
    mHeaderView.mStatus.text = mSS;
    
    mFooterView.mNote.text = self.mBaseOrder.mRemarks;
    mFooterView.mSendPrice.text = [NSString stringWithFormat:@"¥%.2f元",self.mBaseOrder.mDeliverFee];
    mFooterView.mTotalPrice.text = [NSString stringWithFormat:@"¥%.2f元",self.mBaseOrder.mCommodityPrice];
    mFooterView.mOrderCode.text = [NSString stringWithFormat:@"订单编号:%@",self.mBaseOrder.mOrderCode];
    mFooterView.mTime.text = [NSString stringWithFormat:@"下单时间:%@",self.mBaseOrder.mPayTime];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.mBaseOrder.mGoodsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    marketOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    
    [cell setMGoods:self.mBaseOrder.mGoodsArr[indexPath.row]];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    fixDetailViewController *fff = [[fixDetailViewController alloc] initWithNibName:@"fixDetailViewController" bundle:nil];
    //    [self pushViewController:fff];
}

#pragma mark----导航操作
- (void)cellWithBottomLeftBtnAction{
    
    if(self.mBaseOrder.mDistributionAddress.length>0){
        CLGeocoder *stringWithCityName=[[CLGeocoder alloc]init]; //地理编码的类和下面其对应的方法,CLPlacemark是地理信息的类
        [stringWithCityName geocodeAddressString:self.mBaseOrder.mDistributionAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error||!(placemarks.count>0)) {
                MLLog(@"该城市不存在或者搜索有误");
                [self showErrorStatus:@"该城市不存在或者搜索有误"];
            }
            else{
                CLPlacemark *firstObj=[placemarks firstObject]; // 就用第一个位置对象
                CLLocationCoordinate2D cityCoor=firstObj.location.coordinate; //得到城市的纬度和经度
                NSString *strLat=[NSString stringWithFormat:@"%f",cityCoor.latitude];
                NSString *strLong=[NSString stringWithFormat:@"%f",cityCoor.longitude];
                
                
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
                    toLocation.name = self.mBaseOrder.mDistributionAddress;
                    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
                }
                
                
            }
            
        }];
        
    }
    else{
        
        MLLog(@"地理位置不能为空");
        [self showErrorStatus:@"导航地址有误！请查证！"];
        
    }


}
#pragma mark----拨打电话操作
- (void)cellWithBottomRightBtnAction{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.mBaseOrder.mPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark----完成订单操作
- (void)cellWithFinishOrderAction{

    [self showWithStatus:@"正在操作中..."];
    
    [[mUserInfo backNowUser] finishShopOrder:self.mBaseOrder.mOrderId andShopId:self.mBaseOrder.mShopId block:^(mBaseData *resb) {
        
        if (resb.mSucess) {
            [self showSuccessStatus:resb.mMessage];
            [self headerBeganRefresh];
        }else{
        
            [self showErrorStatus:resb.mMessage];
            [self headerBeganRefresh];
        }
        
    }];
    
}
#pragma mark----确认订单操作
- (void)cellWithComfirmOrderAction{

}
#pragma mark----取消订单操作
- (void)cellWithCancelOrderAction{

}
@end
