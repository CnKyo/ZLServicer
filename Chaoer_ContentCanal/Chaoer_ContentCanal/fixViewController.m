//
//  fixViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "fixViewController.h"
#import "fixOrderTableViewCell.h"
#import "fixDetailViewController.h"
#import <MapKit/MapKit.h>

@interface fixViewController ()<UITableViewDelegate,UITableViewDataSource,WKSegmentControlDelagate,cellWithBtnActionDelegate>

@end

@implementation fixViewController
{
    int     mType;
    WKSegmentControl    *mSegmentView;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"物业报修订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    mType =0;
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    self.haveFooter = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"fixOrderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    mSegmentView = [WKSegmentControl initWithSegmentControlFrame:CGRectMake(0, 165, DEVICE_Width, 40) andTitleWithBtn:@[@"等待接单",@"进行中订单",@"已完成订单"] andBackgroudColor:[UIColor whiteColor] andBtnSelectedColor:M_CO andBtnTitleColor:M_TextColor1 andUndeLineColor:M_CO andBtnTitleFont:[UIFont systemFontOfSize:15] andInterval:20 delegate:self andIsHiddenLine:NO andType:1];
    
}


- (void)headerBeganRefresh{
    
    self.page = 1;
    
    [[mUserInfo backNowUser] getFixOrderList:self.page andState:mType block:^(mBaseData *resb, GFixOrder *mOrder) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            [self.tempArray addObjectsFromArray:mOrder.mOrderList];
            [self.tableView reloadData];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self addEmptyView:nil];
        }
        
    }];
    
}

- (void)footetBeganRefresh{
    
    self.page ++;
    
    [[mUserInfo backNowUser] getFixOrderList:self.page andState:mType block:^(mBaseData *resb, GFixOrder *mOrder) {
        
        [self footetEndRefresh];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            [self.tempArray addObjectsFromArray:mOrder.mOrderList];
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
    
    return self.tempArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return mSegmentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (void)WKDidSelectedIndex:(NSInteger)mIndex{
    MLLog(@"点击了%lu",(unsigned long)mIndex);
    
    mType = [[NSString stringWithFormat:@"%ld",(long)mIndex] intValue];
    [self headerBeganRefresh];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 270;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    fixOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    cell.mIndexPath = indexPath;
    cell.delegate = self;
    [cell setMItem:[self.tempArray objectAtIndex:indexPath.row]];
    

    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    fixDetailViewController *fff = [[fixDetailViewController alloc] initWithNibName:@"fixDetailViewController" bundle:nil];
    fff.baseItem = [self.tempArray objectAtIndex:indexPath.row];
    [self pushViewController:fff];
}


- (void)cellWithRightBtnActionIndexPath:(NSIndexPath *)mIndexPath{
    MLLog(@"右边的按钮");
    
    GFixOrderList *mOrder = self.tempArray[mIndexPath.row];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mOrder.mPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)cellWithLeftBtnActionIndexPath:(NSIndexPath *)mIndexPath{
    MLLog(@"左边的按钮");
    
    GFixOrderList *mOrder = self.tempArray[mIndexPath.row];
    
    if(mOrder.mAddress.length>0){
        CLGeocoder *stringWithCityName=[[CLGeocoder alloc]init]; //地理编码的类和下面其对应的方法,CLPlacemark是地理信息的类
        [stringWithCityName geocodeAddressString:mOrder.mAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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
                    toLocation.name = mOrder.mAddress;
                    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
                }
                

            }
            
        }];
        
    }
    else{
        
        MLLog(@"地理位置不能为空");
        [self showErrorStatus:@"地理位置不能为空"];
        
    }

    
    
   
    

    
}

@end
