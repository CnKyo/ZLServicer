//
//  fixDetailViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "fixDetailViewController.h"
#import "fixDetailTableViewCell.h"
#import "mFixBottomView.h"

#import "YXCustomAlertView.h"

#import <MapKit/MapKit.h>

#import "mCheckImgAndVideoView.h"


#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XCAVPlayerView.h"
#import "AMapGeocodeSearch.h"

@interface fixDetailViewController ()<UITableViewDelegate,UITableViewDataSource,cellWithDetailBtnActionDelegate,cellWithBottomViewBtnDelegate,YXCustomAlertViewDelegate,WKCheckImgDelegate>
@property(nonatomic,strong) GFixOrder *orderItem;

@property (nonatomic, strong) XCAVPlayerView *playerView;

@end

@implementation fixDetailViewController
{
    
    mFixBottomView *mBottomView;
    
    YXCustomAlertView *alertV;
    
    UITextField *mPriceTx;
    
    mCheckImgAndVideoView *mCheckView;

    mCheckImgAndVideoView *mCheckVideoView;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     IQKeyboardManager为自定义收起键盘
     **/
    [[IQKeyboardManager sharedManager] setEnable:YES];///视图开始加载键盘位置开启调整
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];///是否启用自定义工具栏
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;///启用手势
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];///视图消失键盘位置取消调整
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];///关闭自定义工具栏
    
}
- (XCAVPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[XCAVPlayerView alloc]init];
    }
    return _playerView;
}


- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"物业报修订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    [self initView];
    [self initCheckImgView];
    [self initVideoView];
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-124) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"fixDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    mBottomView = [mFixBottomView shareView];
    mBottomView.mLeftBtn.hidden = mBottomView.mRightBtn.hidden = YES;
    
    mBottomView.delegate = self;
    
    
    [self.view addSubview:mBottomView];
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(@0);
        make.height.offset(@60);
        make.width.offset(DEVICE_Width);
    }];
    
    
    
    
}
- (void)initCheckImgView{

    
    mCheckView = [mCheckImgAndVideoView shareView];
    mCheckView.frame = self.view.bounds;
    mCheckView.alpha = 0;
    mCheckView.delegate = self;
    [self.view addSubview:mCheckView];
    
}
- (void)showCheckImgView{

    [UIView animateWithDuration:0.35 animations:^{
        mCheckView.alpha = 1;
    }];
}
- (void)hiddenCheckImgView{

    [UIView animateWithDuration:0.35 animations:^{
        mCheckView.alpha = 0;
    }];
}

- (void)initVideoView{

    mCheckVideoView = [mCheckImgAndVideoView shareVideoView];
    mCheckVideoView.frame = self.view.bounds;
    mCheckVideoView.alpha = 0;
    mCheckVideoView.delegate = self;
    [self.view addSubview:mCheckVideoView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statuesBarChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
     self.playerView.frame = CGRectMake(0, 0, DEVICE_Width, 300);
    [mCheckVideoView.mVideoView addSubview:self.playerView];
    self.playerView.playerUrl = [NSURL URLWithString:self.orderItem.mVideoUrl];
    [self.playerView play];


}
- (void)statuesBarChanged:(NSNotification *)sender{
    //    UIInterfaceOrientation statues = [UIApplication sharedApplication].statusBarOrientation;
    //    if (statues == UIInterfaceOrientationPortrait || statues == UIInterfaceOrientationPortraitUpsideDown) {
    //        self.playerView.frame = CGRectMake(0, 20.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.58);
    //    }else if (statues == UIInterfaceOrientationLandscapeLeft || statues == UIInterfaceOrientationLandscapeRight){
    //        self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@--%@",object,[change description]);
}

- (void)moviePlayDidEnd:(NSNotification *)noti{
    
}

- (void)showCheckVideoView{
    self.playerView.playerUrl = [NSURL URLWithString:self.orderItem.mVideoUrl];
    [self.playerView play];
    
    [UIView animateWithDuration:0.35 animations:^{
        mCheckVideoView.alpha = 1;
    }];
}
- (void)hiddenCheckVideoView{
    
    [UIView animateWithDuration:0.35 animations:^{
        mCheckVideoView.alpha = 0;
        [self.playerView pause];
        //[self.playerView resume];
    }];
}
- (void)updatePage{
    NSString *mTT = nil;
    
    if (self.orderItem.mStatus == 4) {
        mTT = @"接受接单";
    }else if (self.orderItem.mStatus == 8){
        mTT = @"完成服务";

    }else{
        mTT = @"服务已完成";
        [mBottomView.mMidBtn setBackgroundColor:[UIColor lightGrayColor]];

    }
    [mBottomView.mMidBtn setTitle:mTT forState:0];
    
    [mCheckView.mImg sd_setImageWithURL:[NSURL URLWithString:self.orderItem.mOrderImage] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    
}

- (void)initPopView{

    
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    
    [alertV removeFromSuperview];
    
    alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 280, dilH) andSuperView:self.navigationController.view];
    alertV.center = CGPointMake(DEVICE_Width/2, DEVICE_Height/2-30);
    alertV.delegate = self;
    alertV.titleStr = @"输入报修价格";
    
    CGFloat loginX = 20;
    mPriceTx = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width - 2 * loginX, 32)];
    mPriceTx.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    mPriceTx.leftViewMode = UITextFieldViewModeAlways;
    mPriceTx.leftView = leftView;
    mPriceTx.keyboardType = UIKeyboardTypeNumberPad;
    mPriceTx.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mPriceTx.layer.borderWidth = 1;
    mPriceTx.layer.cornerRadius = 4;
    [alertV addSubview:mPriceTx];

    
    
    
}

- (void)headerBeganRefresh{
    
    self.page = 1;
    
    [[mUserInfo backNowUser] getOrderDetail:[NSString stringWithFormat:@"%i", _baseItem.mId] block:^(mBaseData *resb, GFixOrder *mFixOrder) {
        
        [self headerEndRefresh];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            self.orderItem = mFixOrder;
            [self updatePage];
            [self.tableView reloadData];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self addEmptyView:nil];
        }
    }];
    
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
    
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 560;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    fixDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    
    
    cell.delegate = self;
    [cell setMOrderDetail:self.orderItem];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark----打电话按钮
- (void)cellWithPhoneBtnAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.orderItem.mPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
#pragma mark----导航按钮
- (void)cellWithNavBtnAction{
    [[AMapGeocodeSearch sharedClient] searchAddress:self.orderItem.mAddress];
    
//    if(self.orderItem.mAddress.length>0){
//        CLGeocoder *stringWithCityName=[[CLGeocoder alloc]init]; //地理编码的类和下面其对应的方法,CLPlacemark是地理信息的类
//        [stringWithCityName geocodeAddressString:self.orderItem.mAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error||!(placemarks.count>0)) {
//                MLLog(@"该城市不存在或者搜索有误");
//                [self showErrorStatus:@"该城市不存在或者搜索有误"];
//            }
//            else{
//                CLPlacemark *firstObj=[placemarks firstObject]; // 就用第一个位置对象
//                CLLocationCoordinate2D cityCoor=firstObj.location.coordinate; //得到城市的纬度和经度
//                NSString *strLat=[NSString stringWithFormat:@"%f",cityCoor.latitude];
//                NSString *strLong=[NSString stringWithFormat:@"%f",cityCoor.longitude];
//                
//                
//                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=0", @"gotoMap",[HTTPrequest getAppName],strLat, strLong] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                //跳转到高德地图
//                NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=0",@"gotoMap",[HTTPrequest getAppName],strLat, strLong];
//                
//                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]] )
//                {//
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//                }
//                else
//                {//ioS map
//                    
//                    CLLocationCoordinate2D to;
//                    to.latitude =  [[NSString stringWithFormat:@"%@",strLat] floatValue];
//                    to.longitude =  [[NSString stringWithFormat:@"%@",strLong] floatValue];
//                    
//                    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//                    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
//                    toLocation.name = self.orderItem.mAddress;
//                    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
//                                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
//                                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
//                }
//                
//                
//            }
//            
//        }];
//        
//    }
//    else{
//        
//        MLLog(@"地理位置不能为空");
//        [self showErrorStatus:@"地理位置不能为空"];
//        
//    }

    
}
#pragma mark----查看图片按钮
- (void)cellWithImgBtnAction{

    if (self.orderItem.mOrderImage.length <= 0) {
        [self showErrorStatus:@"未找到图片！"];
        return;
    }else{
        [self showCheckImgView];
    }
    
    
}
#pragma mark----查看视频按钮
- (void)cellWithVideoBtnAction{

    if (self.orderItem.mVideoUrl.length<=0) {
        [self showErrorStatus:@"未找到视频！"];
        return;
    }else{
        [self showCheckVideoView];
    }
    
    
}
#pragma mark----取消订单按钮
- (void)cellWithCancelOrderBtnAction{
    
  
}
#pragma mark----接受订单按钮
- (void)cellWithAcceptOrderBtnAction{
    

    if (self.orderItem.mStatus == 4) {

        [self showWithStatus:@"正在操作中..."];

        [[mUserInfo backNowUser] merchantAcceptOrder:[mUserInfo backNowUser].mId andOrderId:self.orderItem.mOrderId block:^(mBaseData *resb) {
            
            if (resb.mSucess) {
                [self showSuccessStatus:resb.mMessage];
                [self headerBeganRefresh];
            }else{
                [self showErrorStatus:resb.mMessage];
            }
        }];
        
    }else if (self.orderItem.mStatus == 8){
        
        [self initPopView];
  

    }else{

    }
    
    
    
}

#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [customAlertView dissMiss];
        customAlertView = nil;
        
        MLLog(@"取消");
        
    }else
    {
        MLLog(@"确认");
        [self finish];

    }
}

- (void)finish{

    [self showWithStatus:@"正在操作中..."];
    
    [[mUserInfo backNowUser] merchantFinishOrder:[mUserInfo backNowUser].mId andOrderId:self.orderItem.mOrderId andPrice:[[NSString stringWithFormat:@"%@",mPriceTx.text] floatValue] block:^(mBaseData *resb) {
        if (resb.mSucess) {
            [alertV dissMiss];
            [self showSuccessStatus:resb.mMessage];
            [self headerBeganRefresh];
        }else{
            [self showErrorStatus:resb.mMessage];
        }
    }];
}

#pragma mark----关闭查看图片view
- (void)WKCloseBtnClicked{

    [self hiddenCheckImgView];
    [self hiddenCheckVideoView];
}



@end
