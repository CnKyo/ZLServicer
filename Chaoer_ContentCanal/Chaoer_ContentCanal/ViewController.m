//
//  ViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "ViewController.h"
#import "WebVC.h"
#import "forgetAndChangePwdView.h"
#import "AppDelegate.h"

#import "registViewController.h"

#import "mLoginView.h"
#import "AppDelegate.h"


#import "CRSA.h"
#import "Base64.h"


#import "RSAEncryptor.h"

#import "HomeNewVC.h"
#import "APIObjectDefine.h"
#import "JPUSHService.h"
#import "QUCustomDefine.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController{
    ///判断验证码发送时间
    NSTimer   *timer;
    
    int ReadTime;
    BOOL _bneedhidstatusbar;
    
    UIScrollView    *mScrollerView;
    
    mLoginView  *mLoginV;
    mLoginView  *mBottomView;

    
    NSString    *mCodeStr;
    
    
    /**
     *  微信openid
     */
    NSString *mOpenID;
    /**
     *  昵称
     */
    NSString *mNickName;
    /**
     *  性别
     */
    NSString *mSex;
    /**
     *  头像
     */
    NSString *mHeaderUrl;
    
    int mType;
    
    
    NSString *mRSAKey;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showFrist];

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


- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];

    self.navBar.hidden = YES;
    self.mPageName = self.Title =  @"登录";
    ReadTime = 61;
    self.hiddenBackBtn = YES;
    self.hiddenRightBtn = YES;
    self.navBar.rightBtn.frame = CGRectMake(DEVICE_Width-100, 20, 120, 44);
    self.rightBtnTitle = @"密码登录";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoNeedChange:) name:MyUserNeedUpdateNotification object:nil];
    
    
    mRSAKey = nil;
    [self getRSAKey];
    [self initView];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@", [JPUSHService registrationID]);
    
}

//用户需要更新数据
-(void)handleUserInfoNeedChange:(NSNotification *)note
{
    [[mUserInfo backNowUser] getNowUserInfo:^(mBaseData *resb, mUserInfo *user) {
        
    }];
}


- (void)initView{


    mScrollerView = [UIScrollView new];
    mScrollerView.frame = self.view.bounds;
    mScrollerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mScrollerView];
    
    mLoginV = [mLoginView shareView];
    mLoginV.frame = CGRectMake(0, 64, mScrollerView.mwidth, 389);
    
    
    if ([mUserInfo backNowUser].mPhone) {
        mLoginV.phoneTx.text = [mUserInfo backNowUser].mPhone;
        
    }
    
    
    mLoginV.phoneTx.delegate = mLoginV.codeTx.delegate = self;
    
    [mLoginV.loginBtn addTarget:self action:@selector(mLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mLoginV.mForgetBtn addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [mScrollerView addSubview:mLoginV];
    
  
    
    mScrollerView.contentSize = CGSizeMake(DEVICE_Width, 568);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    
}
#pragma mark----忘记密码
- (void)forgetAction:(UIButton *)sender{
    registViewController *rrr = [[registViewController alloc] initWithNibName:@"registViewController" bundle:nil];
    rrr.mType = 2;
    rrr.block = ^(NSString *content,NSString *mPwd){
        
        mLoginV.phoneTx.text = content;
        mLoginV.codeTx.text = mPwd;
    };
    
    [self presentModalViewController:rrr];
}
#pragma mark----获取RSAkey
- (void)getRSAKey{

    [mUserInfo getRSAKey:^(mBaseData *resb) {
       
        if (resb.mSucess) {
            mRSAKey = resb.mData;
        }else{
            mRSAKey = nil;
        }
    }];
    
}
#pragma mark----登录
- (void)mLoginAction:(UIButton *)sender{
    MLLog(@"登录");
    if (mLoginV.phoneTx.text == nil || [mLoginV.phoneTx.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        
        [mLoginV.phoneTx becomeFirstResponder];
        return;
    }

    if (mLoginV.codeTx.text == nil || [mLoginV.codeTx.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];

        [mLoginV.codeTx becomeFirstResponder];
        
        return;
    }
    
    [self initLogin];
   
}

- (void)initLogin{
    
    [SVProgressHUD showWithStatus:@"正在登录中..."];
    [mUserInfo mUserLogin:mLoginV.phoneTx.text andPassword:[Util RSAEncryptor:mLoginV.codeTx.text] block:^(mBaseData *resb, mUserInfo *mUser) {
        if (resb.mSucess) {
            [self loginOk];
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mMessage];
            
        }
        
        
    }];

}

#pragma  mark -----键盘消失
- (void)tapAction{
    [mLoginV.phoneTx resignFirstResponder];
    [mLoginV.codeTx resignFirstResponder];
    
   
}
#pragma mark----忘记密码
- (void)ConnectionAction:(UIButton *)sender{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    forgetAndChangePwdView *f =[secondStroyBoard instantiateViewControllerWithIdentifier:@"forget"];
    [self presentViewController:f animated:YES completion:nil];

}
#pragma 免责声明事件
- (void)mianzeAction:(UIButton *)sender{
    MLLog(@"免责");
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"免责声明";
//    vc.mUrl = [GInfo shareClient].mProtocolUrl;
    [self pushViewController:vc];
}
#pragma mark----登录成功跳转
- (void)loginOk{
    mLoginV.codeTx.text = nil;
    
    HomeNewVC *vc = [[HomeNewVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

//    [self dismissViewController];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"back"object:self];

    
}

#pragma mark----jpush load
-(void)jpushLoad:(JPushReceiveObject *)item
{
    if (item.type == 1) { //钱包提示消息
        
    } else if (item.type == 2) { //订单消息
        HomeNewVC *vc = [[HomeNewVC alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
        [vc performSelector:@selector(jPusthVCWithType:) withObject:item.order_type afterDelay:0.1];
    } else if (item.type == 3) { //系统消息
        
    }
}

///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制验证码输入长度
#define PASS_LENGHT 20
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==6) {
        res= PASS_LENGHT-[new length];
        
        
    }else
    {
        res= TEXT_MAXLENGTH-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showFrist
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* v = [def objectForKey:@"showed"];
    NSString* nowver = [Util getAppVersion];
    if( ![v isEqualToString:nowver] )
    {
        UIScrollView* firstview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        firstview.showsHorizontalScrollIndicator = NO;
        firstview.backgroundColor = [UIColor colorWithRed:0.937 green:0.922 blue:0.918 alpha:1.000];
        firstview.pagingEnabled = YES;
        firstview.bounces = NO;
        NSArray* allimgs = [self getFristImages];
        
        CGFloat x_offset = 0.0f;
        CGRect f;
        UIImageView* last = nil;
        for ( NSString* oneimgname in allimgs ) {
            UIImageView* itoneimage = [[UIImageView alloc] initWithFrame:firstview.bounds];
            itoneimage.image = [UIImage imageNamed: oneimgname];
            f = itoneimage.frame;
            f.origin.x = x_offset;
            itoneimage.frame = f;
            x_offset += firstview.frame.size.width;
            [firstview addSubview: itoneimage];
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
        [def setObject:nowver forKey:@"showed"];
        [def synchronize];
        _bneedhidstatusbar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}
-(NSArray*)getFristImages
{
    if( DeviceIsiPhone() )
    {
        return @[@"replash-1.png",@"replash.png",@"replash3.png"];
    }
    else
    {
        return @[@"replash-1.png",@"replash.png",@"replash3.png"];
    }
    
}


@end
