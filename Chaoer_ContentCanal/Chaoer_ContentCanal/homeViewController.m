//
//  homeViewController.m
//  Chaoer_ContentCanal
//
//  Created by 王钶 on 16/3/10.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "homeViewController.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"
#import "homeTableViewCell.h"
#import "homeNavView.h"
#import "mGeneralSubView.h"
#import "CurentLocation.h"

#define Height (DEVICE_Width*0.67)

@interface homeViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,MMApBlockCoordinate>

@property (nonatomic,strong)    NSMutableArray  *mBanerArr;

@property(nonatomic,strong) CLLocationManager *locaManager;

@end

@implementation homeViewController
{
    
    homeNavView *mNavView;
    
    AMapLocationManager *mLocation;
    
    /**
     *  纬度
     */
    NSString *mLat;
    /**
     *  经度
     */
    NSString *mLng;
    
    NSString *mDownAppUrl;
    BOOL _bneedhidstatusbar;

    int mIndex;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //设置聊天界面的颜色,风格
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:M_CO];
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavImg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:M_CO];
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([mUserInfo isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    [CurentLocation sharedManager];
    [self upDateUserInfo];
}
- (void)upDateUserInfo{

    [[mUserInfo backNowUser] getNowUserInfo:^(mBaseData *resb, mUserInfo *user) {
      
        
        if (resb.mSucess) {

        }else{
        
        }
    }];
}
#pragma mark----更新app
- (void)dateUpAppVersion{

    [[mUserInfo backNowUser] getUpdateApp:^(mBaseData *resb) {
        if (resb.mSucess) {
            
            mDownAppUrl = [resb.mData objectForKey:@"downloadUrl"];
                        
            if (![[Util getAPPBuildNum] isEqualToString:[resb.mData objectForKey:@"versionsName"]]) {
                [self AlertViewShow:[resb.mData objectForKey:@"fileName"] alertViewMsg:[resb.mData objectForKey:@"content"] alertViewCancelBtnTiele:@"取消" alertTag:99];
            }
            
        }else{
        
            
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"首页";
    self.hiddenBackBtn = YES;
    self.hiddenRightBtn = YES;
    self.hiddenlll = YES;
    self.navBar.hidden = YES;
    self.mBanerArr = [NSMutableArray new];
    [self.mBanerArr removeAllObjects];
    mDownAppUrl = nil;

  
    mIndex = 0;
    
    mLat = nil;
    mLng = nil;
    
    [self callBack];
}

- (void)appInit{

    [Ginfo getGinfo:^(mBaseData *resb) {
        if (resb.mSucess) {
            
        }else{
            
        }
    }];
    
    
    
}

-(void)callBack{
    [self.mBanerArr removeAllObjects];
    MLLog(@"this is Notification.");
    [self showFrist];

    [self appInit];

    [self initview];
    [self dateUpAppVersion];

}
- (void)initview{
    
    mNavView = [homeNavView shareView];
    mNavView.mMsgPoint.hidden = YES;
    mNavView.frame = CGRectMake(0, 0, DEVICE_Width, 64);
    [mNavView.mChtListBtn addTarget:self action:@selector(mRCCListView:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:mNavView];
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    UINib   *nib = [UINib nibWithNibName:@"homeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}
#pragma mark----信息事件
- (void)mRCCListView:(UIButton *)sender{
    
    MLLog(@"消息");
    

}
- (void)headerBeganRefresh{

    [self headerEndRefresh];
    
}
- (void)loadAddress{
    
    [CurentLocation sharedManager].delegate = self;
    [[CurentLocation sharedManager] getUSerLocation];
    
    
    mLocation = [[AMapLocationManager alloc] init];
    mLocation.delegate = self;
    [mLocation setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    mLocation.locationTimeout = 3;
    mLocation.reGeocodeTimeout = 3;
    [mLocation requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSString *eee =@"定位失败！请检查网络和定位设置！";
            [WJStatusBarHUD showErrorImageName:nil text:eee];

            mNavView.mAddress.text = eee;
            MLLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);

        }
        
        MLLog(@"location:%f", location.coordinate.latitude);
        

        
        if (regeocode)
        {
            mLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            mLng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            [WJStatusBarHUD showSuccessImageName:nil text:@"定位成功"];
            
            MLLog(@"reGeocode:%@", regeocode);
            mNavView.mAddress.text = [NSString stringWithFormat:@"%@%@%@",regeocode.formattedAddress,regeocode.street,regeocode.number];
        }
    }];

}
#pragma mark----maplitdelegate
- (void)MMapreturnLatAndLng:(NSDictionary *)mCoordinate{
    
    MLLog(@"定位成功之后返回的东东：%@",mCoordinate);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";

    homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];


    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if( buttonIndex == 1)
        {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mDownAppUrl]];

            
        }
    }else{
    
        if( buttonIndex == 1)
        {
            
            
            
        }

    }
  
}

- (void)AlertViewShow:(NSString *)alerViewTitle alertViewMsg:(NSString *)msg alertViewCancelBtnTiele:(NSString *)cancelTitle alertTag:(int)tag{
    
    UIAlertView* al = [[UIAlertView alloc] initWithTitle:alerViewTitle message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"确定", nil];
    al.delegate = self;
    al.tag = tag;
    [al show];
}

#pragma mark----引导
-(void)showFrist
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* v = [def objectForKey:@"first"];
    NSString* nowver = [Util getAppVersion];
    if( ![v isEqualToString:nowver] )
    {
        UIScrollView* firstview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        firstview.showsHorizontalScrollIndicator = NO;
        firstview.backgroundColor = [UIColor colorWithRed:0.937 green:0.922 blue:0.918 alpha:1.000];
        firstview.pagingEnabled = YES;
        firstview.bounces = NO;
        firstview.scrollEnabled = NO;
        NSArray* allimgs = [self getFristImages];
        
        CGFloat x_offset = 0.0f;
        CGRect f;
        UIImageView* last = nil;
        int tag = 0;
        for ( NSString* oneimgname in allimgs ) {
            UIImageView* itoneimage = [[UIImageView alloc] initWithFrame:firstview.bounds];
            itoneimage.image = [UIImage imageNamed: oneimgname];

            itoneimage.userInteractionEnabled = YES;
            itoneimage.tag = tag;
            UITapGestureRecognizer* imgAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction:)];
            [itoneimage addGestureRecognizer: imgAction];
            
            f = itoneimage.frame;
            f.origin.x = x_offset;
            itoneimage.frame = f;
            x_offset += firstview.frame.size.width;
            [firstview addSubview: itoneimage];
            tag++;
            last  = itoneimage;
        }
        UITapGestureRecognizer* guset = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fristTaped:)];
        last.userInteractionEnabled = YES;
        [last addGestureRecognizer: guset];
        
        CGSize cs = firstview.contentSize;
        cs.width = x_offset;
        firstview.contentSize = cs;
        
        _bneedhidstatusbar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        
        [((UIWindow*)[UIApplication sharedApplication].delegate).window addSubview: firstview];
    }
    
}
- (void)imgAction:(UITapGestureRecognizer*)sender{
    NSArray* allimgs = [self getFristImages];

    UIView* ttt = [sender view];
    UIView* pview = [ttt superview];
    UIImageView *ii = (UIImageView *)ttt;
    
    MLLog(@"%lu",(unsigned long)allimgs.count);
    
    if (mIndex == allimgs.count-1) {

        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect f = pview.frame;
            f.origin.y = -pview.frame.size.height;
            pview.frame = f;
            
        } completion:^(BOOL finished) {
            
            [pview removeFromSuperview];
            
            NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
            NSString* nowver = [Util getAppVersion];
            [def setObject:nowver forKey:@"first"];
            [def synchronize];
            _bneedhidstatusbar = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            
        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            ii.image = [UIImage imageNamed:allimgs[mIndex+1]];
            
        } completion:^(BOOL finished) {
            
            mIndex++;
        }];
    }
    


}
-(void)fristTaped:(UITapGestureRecognizer*)sender
{
    UIView* ttt = [sender view];
    UIView* pview = [ttt superview];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect f = pview.frame;
        f.origin.y = -pview.frame.size.height;
        pview.frame = f;
        
    } completion:^(BOOL finished) {
        
        [pview removeFromSuperview];
        
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        NSString* nowver = [Util getAppVersion];
        [def setObject:nowver forKey:@"first"];
        [def synchronize];
        _bneedhidstatusbar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}
-(NSArray*)getFristImages
{
    if( DeviceIsiPhone() )
    {
        return @[@"splash_one.png",@"splash_two",@"splash_three.png",@"splash_four.png"];
    }
    else
    {
        return @[@"splash_one.png",@"splash_two",@"splash_three.png",@"splash_four.png"];
    }
    
}


@end
