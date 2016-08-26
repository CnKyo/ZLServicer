//
//  dataModel.m
//  Chaoer_ContentCanal
//
//  Created by 王钶 on 16/3/17.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "dataModel.h"
#import "HTTPrequest.h"
#import "NSObject+myobj.h"
#import "APService.h"
#import <MobileCoreServices/UTType.h>


#import "WXApi.h"
#import "WXApiObject.h"

#import <AlipaySDK/AlipaySDK.h>
#import <objc/message.h>

@implementation dataModel{
    NSMutableURLRequest *request;
    NSOperationQueue *queue;
    NSURLConnection *_connection;
    NSMutableData *_reveivedData;
}
+(instancetype)shareInstance{
    static dataModel *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[dataModel alloc]init];
    });
    
    return manager;
}

@end


@interface mBaseData()

@property (nonatomic,strong)    id mcoredat;


@end

@implementation mBaseData

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        self.mData = [obj objectForKeyMy:@"data"];
        [self fetchIt:obj];
    }
    return self;

}
- (void)fetchIt:(NSDictionary *)obj{
    
    _mTitle = [obj objectForKeyMy:@"title"];
    _mState = [[obj objectForKeyMy:@"state"] intValue];
    self.mMessage = [obj objectForKeyMy:@"message"];
    self.mAlert = [[obj objectForKeyMy:@"alert"] intValue];
    self.mData = [obj objectForKeyMy:@"data"];
    
    
    if (self.mState == 200000) {
        self.mSucess = YES;
    }else{
        self.mSucess = NO;
    }
    
}
+ (mBaseData *)infoWithError:(NSString *)error{
    mBaseData *retobj = mBaseData.new;
    retobj.mTitle = @"";
    retobj.mState = 400301;
    retobj.mData = nil;
    retobj.mMessage = @"服务器君开小差啦!";
    return retobj;
}
@end


@implementation Ginfo

+ (void)getGinfo:(void (^)(mBaseData *))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mLoginId) forKey:@"loginId"];
    [para setObject:[Util getAppVersion] forKey:@"appVersion"];
    [para setObject:[Util getDeviceModel] forKey:@"mobileVersion"];
    [para setObject:[Util getDeviceVersion] forKey:@"mobileSystem"];
    [para setObject:[Util getDeviceUUID] forKey:@"imei"];
    [para setObject:@"ios" forKey:@"type"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/login/loginlog" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
        }
        
        block (info);
    }];
    
}

@end

@implementation mUserInfo
{

    NSOperationQueue *queue;
    NSURLConnection *_connection;
    NSMutableData *_reveivedData;
}
static mUserInfo *g_user = nil;
bool g_bined = NO;

+ (mUserInfo *)backNowUser{
    if (g_user) {
        return g_user;
    }
    if (g_bined) {
        MLLog(@"警告！递归错误！");
        return nil;
    }
    g_bined = YES;
    @synchronized (self) {
        if (!g_user) {
            g_user = [mUserInfo loadUserInfo];
        }
    }
    g_bined = NO;
    return g_user;
}
+(mUserInfo*)loadUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"userInfo"];
    if( dat )
    {
        mUserInfo* tu = [[mUserInfo alloc]initWithObj:dat];
        return tu;
    }
    return nil;
}
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mLid = [[obj objectForKeyMy:@"lid"] intValue];
    
    self.mLoginId = [[obj objectForKeyMy:@"loginId"] intValue];
    
    self.mNickName = [obj objectForKeyMy:@"loginName"];
    self.mServiceName = [obj objectForKeyMy:@"serviceName"];
    
    self.mId =  [[obj objectForKeyMy:@"mId"] intValue];
    
    self.mSId =  [[obj objectForKeyMy:@"serviceId"] intValue];
    
    self.mUserImgUrl = [obj objectForKeyMy:@"portrait"];
    self.mCredit = [[obj objectForKeyMy:@"credit"] intValue];
    self.mGrade = [[obj objectForKeyMy:@"grade"] intValue];
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];
    self.mSignature = [obj objectForKeyMy:@"signature"];
    
    int    sss = [[obj objectForKeyMy:@"sex"] intValue];
    if (sss == 1) {
        self.mSex = @"男";
    }else{
        self.mSex = @"女";
    }
    
    
    self.mPhone = [obj objectForKeyMy:@"moblie"];
    self.mPwd = [obj objectForKeyMy:@"mPwd"];
    self.muuid = @"";
    
    
    int mMerchant = [[obj objectForKeyMy:@"is_open_merchant"] intValue];
    
    self.mIsOpenMerchant = mMerchant?1:0;
    
    int mShop = [[obj objectForKeyMy:@"is_open_shop"] intValue];
    
    self.mIsOpenShop = mShop?1:0;;
    
    int mClean = [[obj objectForKeyMy:@"is_open_clean"] intValue];
    
    self.mIsOpenClean = mClean?1:0;;
    
    NSMutableArray *mArr = [NSMutableArray new];
    [mArr removeAllObjects];
    
    for (NSDictionary *dic in [obj objectForKeyMy:@"shopList"]) {
        [mArr addObject:[[GShopList alloc] initWithObj:dic]];
    }
    
    self.mOrderArr = mArr;
    
    self.mShopId = [[obj objectForKeyMy:@"sId"] intValue];
    self.mEmail = [obj objectForKeyMy:@"email"];
    
    
    NSString *mTT = @"";

    for (int i =0;i<self.mOrderArr.count;i++) {
        
        GShopList *dic = self.mOrderArr[i];
        
        
        if (i == self.mOrderArr.count-1) {
            mTT = [mTT stringByAppendingString:[NSString stringWithFormat:@"%@",dic.mCategry]];
        }else{
            mTT = [mTT stringByAppendingString:[NSString stringWithFormat:@"%@,",dic.mCategry]];
        }
        
    }
    self.mServiceType = mTT;
    
    
}
+(void)cleanUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"userInfo"];
    [def synchronize];
}

+ (BOOL)isNeedLogin{
    return [mUserInfo backNowUser] == nil;
}
//退出登陆
+(void)logOut
{
    [mUserInfo closePush];
    g_user = nil;
    [mUserInfo cleanUserInfo];
    
}
- (BOOL)isVaildUser{
    return self.muuid != 0;
}
- (BOOL)mTemporary{
    return self.mId == 0;
}
#pragma mark----获取rsa加密公钥
/**
 *  获取rsa加密公钥
 *
 *  @param block
 */
+ (void)getRSAKey:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/login/getPublicKey" parameters:para call:^(mBaseData * _Nonnull info) {
        block (info);
    }];
    
}


+ (void)getRegistVerifyCode:(NSString *)mPhone block:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mPhone forKey:@"loginName"];
    
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/auth/ForgetPassword" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            block (info);
        }else
            block(info);
    }];
}
/**
 *  修改密码
 *
 *  @param mPhone  手机
 *  @param mOldPwd 旧密码
 *  @param mNewPwd 新密码
 *  @param block   返回值
 */
+ (void)modifyPwd:(NSString *)mPhone andOldPwd:(NSString *)mOldPwd andNewPwd:(NSString *)mNewPwd block:(void(^)(mBaseData *resb, mUserInfo *mUser))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[Util RSAEncryptor:mPhone] forKey:@"loginName"];
    [para setObject:[Util RSAEncryptor:mOldPwd] forKey:@"oPass"];
    [para setObject:[Util RSAEncryptor:mNewPwd] forKey:@"nPass"];
    [para setObject:@"ios" forKey:@"device"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/auth/upPass" parameters:para call:^(mBaseData *info) {
        [self dealUserSession:info andPhone:mNewPwd andOpenId:nil block:block];

    }];
}
+ (void)mUserRegist:(NSString *)mPhoneNum andCode:(NSString *)mCode andPwd:(NSString *)mPwd andIdentity:(NSString *)mId block:(void (^)(mBaseData *))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mPhoneNum forKey:@"loginName"];
    [para setObject:mCode forKey:@"verfyCode"];
    [para setObject:mPwd forKey:@"passWord"];
    if (mId) {
    [para setObject:mId forKey:@"identity"];    
    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/auth/register" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
        
            block (info);
        }else{
            block (info);
        }
    }];
}

+ (void)mWechatRegist:(NSDictionary *)mPara block:(void(^)(mBaseData *resb))block{

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/wxBind/register" parameters:mPara call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block (info);
        }else{
            block (info);
        }
    }];
    
}
/**
 *  报修支付
 *
 *  @param mPayType 支付类型
 *  @param mPrice   价格
 *  @param mCode    编号
 *  @param block    返回值
 */
- (void)payType:(int)mPayType andPrice:(float)mPrice andCode:(NSString *)mCode block:(void(^)(mBaseData* resb))block{
    
    int mType;
    
    if (mPayType == 1) {
        /**
         *  微信支付
         */
        mType = 3;
        
        [self Pay:mPrice andType:mType andCode:mCode block:block];
        
    }else if (mPayType == 2){
        /**
         *  支付宝支付
         */
        mType = 4;
        [self Pay:mPrice andType:mType andCode:mCode block:block];

    }else if (mPayType == 3){
        /**
         *  银行卡支付
         */
        mType = 1;
        block( [mBaseData infoWithError:@"不支持的支付方式!"] );


    }else{
        /**
         *  余额支付
         */
        mType = 6;
        [self Pay:mPrice andType:mType andCode:mCode block:block];


    }
    
//    if( [mPayType isEqualToString:@"wx"] )
//    {
//        [self wxPay:mPrice block:block];
//    }
//    else if ([mPayType isEqualToString:@"alipay"]){
//        
//        [self aliPay:mPrice block:block];
//    }
//    else{
//        block( [mBaseData infoWithError:@"不支持的支付方式!"] );
//        
//    }
    
}
-(void)Pay:(float)Price andType:(int)mType andCode:(NSString *)mCode block:(void(^)(mBaseData* retobj))block{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%.2f",Price]] forKey:@"price"];
    [param setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%d",[mUserInfo backNowUser].mUserId]] forKey:@"userId"];
    [param setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%d",mType]] forKey:@"channel"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:[Util RSAEncryptor:mCode] forKey:@"code"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/payment/payment_repair" parameters:param call:^(mBaseData *info) {
        
        if( info.mSucess )
        {
            if (mType == 3) {
                NSString* typestr = [info.mData objectForKeyMy:@"channel"];
                if( [typestr isEqualToString:@"wx"] )
                {
                    
                    
                    [SVProgressHUD dismiss];
                    SWxPayInfo* wxpayinfo = [[SWxPayInfo alloc]initWithObj:info.mData];
                    [mUserInfo backNowUser].mPayBlock = ^(mBaseData *retobj) {
                        
                        if( retobj.mSucess )
                        {//如果成功了,就更新下
                            block(retobj);//再回调获取
                            
                        }else
                            block(retobj);//再回调获取
                        [mUserInfo backNowUser].mPayBlock = nil;
                        
                    };
                }
                else
                {
                    mBaseData* itretobj = [mBaseData infoWithError:@"支付出现异常,请稍后再试"];
                    block(itretobj);//再回调获取
                }
            }else if (mType == 4){
                NSString *mPayInfo = [info.mData objectForKey:@"packages"];
                
                
                
                [SVProgressHUD dismiss];
                
                
                
                [mUserInfo backNowUser].mPayBlock = ^(mBaseData *retobj) {
                    
                    if( retobj.mSucess )
                    {//如果成功了,就更新下
                        block(retobj);//再回调获取
                        
                    }else
                        block(retobj);//再回调获取
                    [mUserInfo backNowUser].mPayBlock = nil;
                    
                };
                
                
                [[AlipaySDK defaultService] payOrder:mPayInfo fromScheme:@"zerolife" callback:^(NSDictionary *resultDic) {
                    
                    MLLog(@"xxx:%@",resultDic);
                    
                    mBaseData* retobj = nil;
                    
                    if (resultDic)
                    {
                        if ( [[resultDic objectForKey:@"resultStatus"] intValue] == 9000 )
                        {
                            retobj = [[mBaseData alloc]init];
                            retobj.mSucess = YES;
                            retobj.mMessage = @"支付成功";
                            retobj.mState = 200000;
                        }
                        else
                        {
                            retobj = [mBaseData infoWithError: [resultDic objectForKey:@"memo" ]];
                        }
                    }
                    else
                    {
                        retobj = [mBaseData infoWithError: @"支付出现异常"];
                    }
                    
                    if(  [mUserInfo backNowUser].mPayBlock )
                    {
                        [mUserInfo backNowUser].mPayBlock( retobj );
                    }
                    else
                    {
                        MLLog(@"alipay block nil?");
                    }
                    
                }];
            }else if (mType == 1){
            
            }else{
            
                block (info);
            }
            
         
        }
        else
            block( info );
    }];
    
    
}
+ (void)mUserLogin:(NSString *)mLoginName andPassword:(NSString *)mPwd block:(void (^)(mBaseData *resb, mUserInfo *mUser))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[Util RSAEncryptor:mLoginName] forKey:@"loginName"];
    [para setObject:mPwd forKey:@"passWord"];
    [para setObject:@"ios" forKey:@"device"];
    [para setObject:[Util getAppVersion] forKey:@"app"];
    [para setObject:[Util getDeviceModel] forKey:@"mobileVersion"];
    [para setObject:[Util getDeviceVersion] forKey:@"mobileSystem"];
    [para setObject:[Util getDeviceUUID] forKey:@"imei"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/auth/login" parameters:para call:^(mBaseData *info) {
        [self dealUserSession:info andPhone:mPwd andOpenId:nil block:block];
    }];
    
}
+ (void)mVerifyOpenId:(NSDictionary *)mOpenId block:(void (^)(mBaseData *resb, mUserInfo *mUser))block{
 
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/wxBind/login" parameters:mOpenId call:^(mBaseData *info) {
        
        [self dealUserSession:info andPhone:nil andOpenId:[mOpenId objectForKey:@"openid"] block:block];
    }];
    
    
    
}

+ (void)mLoginWithWechat:(NSString *)mLoginName andPassword:(NSString *)mPwd andOpenId:(NSString *)mOpenId block:(void (^)(mBaseData *resb, mUserInfo *mUser))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mLoginName forKey:@"loginName"];
    [para setObject:mPwd forKey:@"passWord"];
    [para setObject:mOpenId forKey:@"openid"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/wxBind/wxPhoneBind" parameters:para call:^(mBaseData *info) {
        [self dealUserSession:info andPhone:mPwd  andOpenId:mOpenId block:block];
    }];
    
}


+(void)mForgetPwd:(NSString *)mLoginName andNewPwd:(NSString *)mPwd block:(void (^)(mBaseData *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[Util RSAEncryptor:mLoginName] forKey:@"loginName"];
    [para setObject:[Util RSAEncryptor:mPwd] forKey:@"nPass"];
    [para setObject:@"ios" forKey:@"device"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"service/auth/modifyPassword" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            block (info);

        }else{
            block (info);

        }
    }];


}

- (void)getNowUserInfo:(void(^)(mBaseData *resb,mUserInfo *user))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
 
//    [para setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%d",[mUserInfo backNowUser].mSId]] forKey:@"serviceId"];
//    [para setObject:@"ios" forKey:@"device"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:@"ios" forKey:@"device"];
 
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/user/homeRefresh" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            [mUserInfo dealUserSession:info andPhone:nil andOpenId:nil block:block];
        }else{
            block (info,[mUserInfo backNowUser]);
        }

    }];


}


+(void)saveUserInfo:(NSDictionary *)dccat
{
    dccat = [Util delNUll:dccat];
    
    NSMutableDictionary *dcc = [[NSMutableDictionary alloc] initWithDictionary:dccat];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:dcc forKey:@"userInfo"];
    
    
    
    [def synchronize];
}


+(void)dealUserSession:(mBaseData*)info andPhone:(NSString *)mPara andOpenId:(NSString *)mOpenid block:(void(^)(mBaseData* resb, mUserInfo*user))block
{
    
#warning 返回的数据是整个用户信息对象
    if ( info.mSucess || info.mState == 200011) {
        NSDictionary* tmpdic = info.mData;
        
        NSMutableDictionary* tdic = [[NSMutableDictionary alloc]initWithDictionary:info.mData];
//        NSString* fucktoken = [info.mcoredat objectForKeyMy:@"token"];
//        if( fucktoken.length )
//            [tdic setObject:fucktoken forKey:@"token"];
//        else
//        {//如果没有token,那弄原来的
////            [tdic setObject:[SUser currentUser].mToken forKey:@"token"];
//        }
        
        if (mPara) {
            [tdic setObject:mPara forKey:@"mPwd"];
        }else{
            [tdic setObject:[mUserInfo backNowUser].mPwd forKey:@"mPwd"];

        }
        if (mOpenid) {
            [tdic setObject:mOpenid forKey:@"mOpenId"];

        }
        
        mUserInfo* tu = [[mUserInfo alloc]initWithObj:tdic];
        tmpdic = tdic;
        if ([tu isVaildUser]) {
            [mUserInfo saveUserInfo:tmpdic];
            g_user = nil;
            
        }
        
        [mUserInfo openPush];


    }
    
    
    block( info , [mUserInfo backNowUser] );
    
}


#pragma mark----更新app
/**
 *  更新app
 *
 *  @param block 返回值
 */
- (void)getUpdateApp:(void(^)(mBaseData *resb))block{

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/versions/getVersionNumber" parameters:nil call:^(mBaseData *info) {
        
        block (info);
    }];
    
    
}

+ (void)editUserMsg:(NSString *)mHeader andUserid:(int)mUserid andLoginName:(NSString *)mLoginName andNickName:(NSString *)nickName andSex:(NSString *)mSex andSignate:(NSString *)mSignate block:(void(^)(mBaseData *resb,mUserInfo *mUser))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserid) forKey:@"userId"];
    if (mLoginName) {
        [para setObject:mLoginName forKey:@"loginName"];
    }
    
    if (nickName) {
        [para setObject:nickName forKey:@"nickName"];
    }
    if (mSex) {
        [para setObject:mSex forKey:@"sex"];
        
    }
    if (mSignate) {
        [para setObject:mSignate forKey:@"signature"];
        
    }
    if (mHeader) {
        [para setObject:mHeader forKey:@"portrait"];
        
    }
    
    if ([mUserInfo backNowUser].mPhone.length != 0) {
        [para setObject:[mUserInfo backNowUser].mPhone forKey:@"moblie"];

    }
    
    

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/updUser/appModfiyUser" parameters:para call:^(mBaseData *info) {
        
        [self dealUserSession:info andPhone:nil andOpenId:nil block:block];

    }];
    
}
+ (void)modifyUserImg:(int)mUserId andImage:(NSData *)mImg andPath:(NSString *)mPath block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[NSString stringWithFormat:@"%d",[mUserInfo backNowUser].mUserId] forKey:@"userId"];
    [para setObject:mImg forKey:@"file"];
    
    
    NSString    *mUrlStr = [NSString stringWithFormat:@"%@app/updUser/appModfiyHead",[HTTPrequest returnNowURL]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:mUrlStr] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30];
    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";


    
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = @{
                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                    };
    
    //multipart/form-data格式按照构建上传数据
    NSMutableData *postData = [[NSMutableData alloc]init];
    for (NSString *key in para) {
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
        [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [para objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([value isKindOfClass:[NSData class]]){
            [postData appendData:value];
        }
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //文件部分
    NSString *filename = [mPath lastPathComponent];
    NSString *contentType = AFContentTypeForPathExtension([mPath pathExtension]);
    
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type=%@\r\n\r\n",boundary,@"file",filename,contentType];
    [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[postData appendData:[@"测试文件数据" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:mImg]; //加入文件的数据
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = postData;
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
  NSURLConnection * _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [_connection start];

 
    
  

}

#pragma mark----查询银行卡
/**
 *  查询银行卡
 *
 *  @param block fanhuizhi
 */
- (void)getBankInfo:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mSId ) forKey:@"serviceId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/user/bank" parameters:para call:^(mBaseData * _Nonnull info) {
        
        block(info);
 
    }];
    
}
#pragma mark----获取账单纪录
/**
 *  获取账单纪录
 *
 *  @param block fanhuizhi
 */
- (void)getTradeHistoryList:(int)mPage block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mSId ) forKey:@"serviceId"];
    [para setObject:NumberWithInt(10) forKey:@"rows"];
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/bill/orderRecord" parameters:para call:^(mBaseData * _Nonnull info) {
        NSMutableArray *tempArr = [NSMutableArray new];
        [tempArr removeAllObjects];
        if (info.mSucess) {
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GTradeHistory alloc] initWithObj:dic]];
            }
            block(info,tempArr);

            
        }else{
        
            block(info,tempArr);
        }
    }];
    
    
}

#pragma mark----获取物业报修订单
/**
 *  获取物业报修订单
 *
 *  @param mPage  分页
 *  @param mState 状态 4:报修申请8:服务中
 5:服务完成6:完成
 
 *  @param block  返回值
 */
- (void)getFixOrderList:(int)mPage andState:(int)mState block:(void(^)(mBaseData *resb,GFixOrder *mOrder))block{

    
    NSString *mType = nil;
    
    if (mState == 0) {
        mType = @"4";
    }else if (mState == 1){
        mType = @"8";
    }else{
        mType = @"5";
    }
    
    NSLog(@"%i", ([mUserInfo backNowUser].mLid ));
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    //[para setObject:NumberWithInt([mUserInfo backNowUser].mId ) forKey:@"mId"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:mType forKey:@"state"];
    [para setObject:@"ios" forKey:@"device"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/warrantyOrder/getWarrantyOrderList" parameters:para call:^(mBaseData * _Nonnull info) {
//        NSMutableArray *tempArr = [NSMutableArray new];
//        [tempArr removeAllObjects];
        if (info.mSucess) {
            
//            for (NSDictionary *dic in info.mData) {
//                [tempArr addObject:[[GFixOrder alloc] initWithObj:dic]];
//            }
            block(info,[[GFixOrder alloc] initWithObj:info.mData]);
            
            
        }else{
            
            block(info,nil);
        }
    }];
    
}

/**
 *  获取商家订单列表
 *
 *  @param mPage  分页
 *  @param mState 状态
 *  @param block  返回值
 */
- (void)getShoppingOrderList:(int)mPage andState:(int)mState type:(kShopType)type block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    
    NSString *mType = nil;
    
    if (mState == 0) {
        mType = [NSString stringWithFormat:@"%i", kOrderState_peiIng];
    }else if (mState == 1){
        mType = [NSString stringWithFormat:@"%i", kOrderState_done];
    }else{
        mType = [NSString stringWithFormat:@"%i", kOrderState_cancel];
    }
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:StringWithInt(type) forKey:@"orderType"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    //[para setObject:NumberWithInt([mUserInfo backNowUser].mShopId ) forKey:@"sId"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:mType forKey:@"state"];
    [para setObject:@"ios" forKey:@"device"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/shOrder/shoppingOrderList" parameters:para call:^(mBaseData * _Nonnull info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        [tempArr removeAllObjects];
        if (info.mSucess) {
            
            
            for (NSDictionary *dic in [info.mData objectForKeyMy:@"list"]) {

                [tempArr addObject:[[GShopOrder alloc] initWithObj:dic]];
            }
            
            
            block(info,tempArr);
        }else{
            block(info,tempArr);
        }
    }];
    
}

#pragma mark----报修商户接单接口
/**
 *  报修商户接单接口
 *
 *  @param mId      商家id
 *  @param mOrderId 订单id
 *  @param block    返回值
 */
- (void)merchantAcceptOrder:(int)mId andOrderId:(int)mOrderId block:(void(^)(mBaseData *resb))block{

 
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    //[para setObject:NumberWithInt(mId) forKey:@"mid"];
    [para setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:@"ios" forKey:@"device"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/warrantyOrder/receiving" parameters:para call:^(mBaseData * _Nonnull info) {
        block ( info );
    }];
    

}

#pragma mark----报修商户完成服务接口
/**
 *  报修商户完成服务接口
 *
 *  @param mId      商家id
 *  @param mOrderId 订单id
 *  @param mPrice   最终价格
 *  @param block    返回值
 */
- (void)merchantFinishOrder:(int)mId andOrderId:(int)mOrderId andPrice:(float)mPrice block:(void(^)(mBaseData *resb))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    //[para setObject:NumberWithInt(mId) forKey:@"mid"];
    [para setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [para setObject:NumberWithFloat(mPrice) forKey:@"offer"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:@"ios" forKey:@"device"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/warrantyOrder/serviceCompletion" parameters:para call:^(mBaseData * _Nonnull info) {
        block ( info );
    }];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    MLLog(@"reveive Response:\n%@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!_reveivedData) {
        _reveivedData = [[NSMutableData alloc]init];
    }
    
    [_reveivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    MLLog(@"received Data:\n%@",[[NSString alloc] initWithData:_reveivedData encoding:NSUTF8StringEncoding]);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    MLLog(@"fail connect:\n%@",error);
}


static inline NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}

#pragma mark----获取红包信息
+ (void)getRedBag:(int)mUserId andType:(NSString *)mType block:(void(^)(mBaseData *resb,NSArray *marray))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:mType forKey:@"type"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/redpackage/appRedPackage" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *temparr = [NSMutableArray new];
            for (NSDictionary *dic in info.mData) {
                [temparr addObject:[[SRedBag alloc] initWithObj:dic]];
            }
            
            block( info,temparr);
        }else{
            block( info,nil);

        }
    }];
}


+ (void)verifyUserPhone:(NSString *)mPhone andNum:(float)mMoney block:(void (^)(mBaseData *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mPhone forKey:@"phone"];
    [para setObject:NumberWithFloat(mMoney) forKey:@"money"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/convenience/appIsRecharge" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            block ( info );
            
        }else{
            block ( info );
        }
    }];
}
+ (void)getBalanceVerifyCode:(NSString *)mSellerName andLoginName:(NSString *)mLoginName andPayMoney:(int)mMoney andPayName:(NSString *)mPayName andIdentify:(NSString *)mIdentify andPhone:(NSString *)mPhone andBalance:(int)mBalance andBankCard:(NSString *)mBankCard andBankTime:(NSString *)mTime andCVV:(NSString *)mCVV block:(void(^)(mBaseData *resb))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mSellerName forKey:@"merchantName"];
    [para setObject:mLoginName forKey:@"userMoblie"];
    [para setObject:NumberWithInt(mBalance) forKey:@"userBalance"];
    [para setObject:NumberWithInt(mMoney) forKey:@"buyerMoney"];
//    [para setObject:NumberWithFloat(0.1) forKey:@"buyerMoney"];
    [para setObject:mPayName forKey:@"buyerName"];
    [para setObject:mIdentify forKey:@"buyerCard"];
    [para setObject:mPhone forKey:@"buyerPhone"];
    [para setObject:mBankCard forKey:@"buyerBankCard"];
    [para setObject:mTime forKey:@"buyerBankExpire"];
    [para setObject:mCVV forKey:@"buyerBankCvv"];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/epos/pay/appHandleFunc" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block( info );
            
        }else{
            block( info );
        }
    }];
    
}


#pragma mark----实名认证（获取省市区）
/**
 *  实名认证（获取省市区）
 *
 *  @param block 返回值
 */
- (void)getCodeAddress:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/region/getRegion" parameters:nil call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GCodeProvince alloc] initWithObj:dic]];
            }
            
            block ( info ,tempArr );
            
        }else{
            block ( info ,nil );
        }
    }];

    
    
}

+ (void)getCityId:(int)mCityId block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mCityId) forKey:@"parentId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/city/appWebSite" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GCity alloc] initWithObj:dic]];
            }
            
            block ( info ,tempArr );
            
        }else{
            block ( info ,nil );
        }
    }];
}

+ (void)getArearId:(NSString *)mProvince andArear:(NSString*)mArear andCity:(NSString *)mCity block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mProvince forKey:@"propertyId"];
    [para setObject:mArear forKey:@"cityId"];
    [para setObject:mCity forKey:@"areaId"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/zocompany/appZocompany" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GCommunity alloc] initWithObj:dic]];
            }
            
            block ( info ,tempArr);
            
        }else{
            block ( info ,nil);
        }
    }];
}



+ (void)getBuildId:(int)mCId block:(void (^)(mBaseData *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mCId) forKey:@"cId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"zm/front/personal/village.do" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
        }else{
            
        }
    }];
}

+ (void)getBuilNum:(int)mId block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mId) forKey:@"propertyId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/house/appHouseList" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[dic objectForKey:@"ban"]];
            }
            
            block ( info , tempArr);
            
        }else{
            block ( info , nil);
        }
    }];
}

+ (void)getDoorNum:(int )mName andBuildName:(int)mBuildName block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mName) forKey:@"propertyId"];
    [para setObject:NumberWithInt(mBuildName) forKey:@"unitNum"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/house/appHouseUnit" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                
                [tempArr addObject:[[GdoorNum alloc] initWithObj:dic]];
                
            }
            
            block (info,tempArr);

            
        }else{
            block (info,nil);
        }
    }];
}

+ (void)getBundleMsg:(int)mUserId block:(void (^)(mBaseData *, SVerifyMsg *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/epos/realVerify/appBankInfo" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            SVerifyMsg *mVerify = [[SVerifyMsg alloc] initWithObj:info.mData];
            
            block( info,mVerify);
        }else{
            block( info,nil);

        }
    }];
}
#pragma mark----获取楼栋门牌号
/**
 *  获取楼栋门牌号
 *
 *  @param mCommunityId 小区id
 *  @param block        返回值
 */
- (void)getBanAndUnitAndFloors:(NSString *)mCommunityId block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mCommunityId forKey:@"communityId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/communityCenter/getBan" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {

            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                
                GAddArearObj *mAddObj = [[GAddArearObj alloc] initWithObj:dic];
               
              
                
                [tempArr addObject:mAddObj];
            }
            
            block( info,tempArr);
        }else{
            block( info,nil);
            
        }
    }];
    
    
    
}

+ (void)realCode:(NSString *)mName andUserId:(int)mUserid andCommunityId:(int)mCommunityId andBannum:(NSString *)mBannum andUnnitnum:(NSString *)mUnitNum andFloor:(NSString *)mFloor andDoornum:(NSString *)mDoorNum andIdentity:(NSString *)mId block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    if (mName) {
        [para setObject:mName forKey:@"userName"];
    }
    if (mId) {
        [para setObject:mId forKey:@"customerType"];

    }
    [para setObject:NumberWithInt(mUserid) forKey:@"userId"];
    [para setObject:NumberWithInt(mCommunityId) forKey:@"propertyId"];
    [para setObject:mBannum forKey:@"banNum"];
    [para setObject:mUnitNum forKey:@"unitNum"];
    [para setObject:mFloor forKey:@"floorNum"];
    [para setObject:mDoorNum forKey:@"roomNum"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/house/appBindHouse" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block( info);
        }else{
            block( info);
            
        }
    }];

    
}

#pragma mark----实名认证
- (void)realyCodeAndCommunityId:(int)mType andName:(NSString *)mName andCommunityId:(NSString *)mCommunityId andBanNum:(NSString *)mBanNum andUnitNum:(NSString *)mUnitNum andFloorNum:(NSString *)mFloor andRoomNum:(NSString *)mroomNum andIdentify:(NSString *)mIdentify andAddcommunity:(BOOL)mIsAddCommunity andcommunityName:(NSString *)mcommunityName andAddress:(NSString *)mAddress andProvinceID:(NSString *)mProvinceId andArearId:(NSString *)mArearId andCityId:(NSString *)mCityID andPhone:(NSString *)mPhone block:(void(^)(mBaseData *resb))block{

    NSString *mUrlStr = nil;
    NSMutableDictionary *para = [NSMutableDictionary new];

    if (mType == 1) {
        mUrlStr = @"app/house/appBindHouse";
    }else{
        mUrlStr = @"app/house/appAddHouse";
    }

    [para setObject:mName forKey:@"ownerName"];

    
   
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:mPhone forKey:@"mobile"];

    [para setObject:mCommunityId forKey:@"propertyId"];
    [para setObject:mBanNum forKey:@"banNum"];
    [para setObject:mUnitNum forKey:@"unitNum"];
    [para setObject:mFloor forKey:@"floorNum"];
    [para setObject:mroomNum forKey:@"roomNum"];
    [para setObject:mIdentify forKey:@"customerType"];
    [para setObject:NumberWithBool(mIsAddCommunity) forKey:@"isAddCommunity"];
    
    if (mIsAddCommunity) {
        [para setObject:mcommunityName forKey:@"communityName"];
        [para setObject:mAddress forKey:@"address"];
        [para setObject:mProvinceId forKey:@"province"];
        [para setObject:mArearId forKey:@"city"];
        [para setObject:mCityID forKey:@"county"];

    }
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrlStr parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block( info);
        }else{
            block( info);
            
        }
    }];

    
    
    
}







- (void)addHouse:(int)mCommunityId andBannum:(NSString *)mBannum andUnnitnum:(NSString *)mUnitNum andFloor:(NSString *)mFloor andDoornum:(NSString *)mDoorNum andIdentity:(NSString *)mId block:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mCommunityId) forKey:@"propertyId"];
    [para setObject:mBannum forKey:@"banNum"];
    [para setObject:mUnitNum forKey:@"unitNum"];
    [para setObject:mFloor forKey:@"floorNum"];
    [para setObject:mDoorNum forKey:@"roomNum"];
    if (mId) {
        [para setObject:mId forKey:@"customerType"];
        
    }
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/house/appAddHouse" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block( info);
        }else{
            block( info);
            
        }
    }];
}



+ (void)getbank:(void(^)(mBaseData *resb,NSArray *marr))block
{    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/bank/appBankList?&paramName=bankname" parameters:nil call:^(mBaseData *info) {
        if (info.mData) {
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[dic objectForKey:@"bankname"]];
            }
            
            block( info,tempArr);
        }else{
            block( info,nil);
            
        }
    }];
    
    

}

+ (void)getBankOfCity:(NSString *)mCity andProvince:(NSString *)mProvince andBankName:(NSString *)mName andType:(int)mType block:(void(^)(mBaseData *resb,NSArray *marr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];

    NSString *url = nil;
    
   if (mType ==2){
       url = @"app/bank/appBankList?&paramName=province";
       [para setObject:mName forKey:@"bankname"];
       
    }else if (mType ==3){
        url = @"app/bank/appBankList?&paramName=city&";
        
        [para setObject:mProvince forKey:@"province"];
        [para setObject:mName forKey:@"bankname"];

        
    }else if (mType == 4){
        url = @"app/bank/appBankList?&paramName=name&";
        [para setObject:mProvince forKey:@"province"];
        [para setObject:mCity forKey:@"city"];
        [para setObject:mName forKey:@"bankname"];

    }
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:url parameters:para call:^(mBaseData *info) {

        if (info.mSucess) {
            NSMutableArray *tempArr = [NSMutableArray new];
            
            
            if (mType == 3) {
                for (NSDictionary *dic in info.mData) {
                    
                    [tempArr addObject:[dic objectForKey:@"city"]];
                }
                
            }else if(mType ==4){
                
                [tempArr addObjectsFromArray:info.mData];
            }else{
                for (NSDictionary *dic in info.mData) {
                    
                    [tempArr addObject:[dic objectForKey:@"province"]];
                }
            }
            
            
            
            block( info,tempArr);
        }else{
            block( info,nil);
            
        }
    }];
}



+ (void)geBankCode:(NSString *)mName andUserId:(int)mUserId andIdentify:(NSString *)mIdentify andBankName:(NSString *)mBankName andProvince:(NSString *)mProvince andCity:(NSString *)mCity andPoint:(NSString *)mPoint andBankCard:(NSString *)mCard andBankCode:(NSString *)mBankCode block:(void(^)(mBaseData *resb))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:mName forKey:@"name"];
    [para setObject:mIdentify forKey:@"card"];
    [para setObject:mBankName forKey:@"bankName"];
    [para setObject:mProvince forKey:@"bankProvince"];
    [para setObject:mCity forKey:@"bankCity"];
    [para setObject:mPoint forKey:@"bankWebSite"];
    [para setObject:mCard forKey:@"bankCard"];
    
    [para setObject:mBankCode forKey:@"bankCode"];

    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/epos/realVerify/appRealNameVerify" parameters:para call:^(mBaseData *info) {
        if (info.mSucess ) {
            
            block (info);
            
        }else{
            block (info);
        }
    }];

    
    
    
    
}




+ (void)getBaner:(void (^)(mBaseData *, NSArray *))block{
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/banner/getBanner" parameters:nil call:^(mBaseData *info) {
        NSMutableArray *temparr = [NSMutableArray new];
        if (info.mSucess ) {
            
            for (NSDictionary *dic in info.mData) {
                [temparr addObject:[[MBaner alloc] initWithObj:[dic objectForKey:@"attrs"]]];
            }
            block (info,temparr);
            
        }else{
            block (info,nil);
        }
    }];
}


#pragma mark----获取跑跑腿baner横幅
/**
 *  获取baner横幅
 *
 *  @param block 返回值
 */
- (void)getPPTbaner:(void(^)(mBaseData *resb,NSArray *mBaner))block{

    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appLegBanner" parameters:nil call:^(mBaseData *info) {
        NSMutableArray *temparr = [NSMutableArray new];
        if (info.mSucess ) {
            
            for (NSDictionary *dic in info.mData) {
                [temparr addObject:[[GPPTBaner alloc] initWithObj:dic]];
            }
            block (info,temparr);
            
        }else{
            block (info,nil);
        }
    }];
    
    
    
}


+ (void)feedCompany:(int)mUserId andContent:(NSString *)mContent block:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:mContent forKey:@"complainReason"];
    [para setObject:@"3" forKey:@"type"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/complain/companyOpinion" parameters:para call:^(mBaseData *info) {
        if (info.mSucess ) {
            block (info);
        }else{
            block (info);
        }
    }];
}

+ (void)feedPerson:(NSString *)mValligeId andBuilId:(NSString *)mBuildId andUnit:(NSString *)mUnitId andFloor:(NSString *)mFloor andDoornum:(NSString *)mdoornum andReason:(NSString *)mReason block:(void(^)(mBaseData *resb))blovk{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:@"1" forKey:@"type"];
    [para setObject:mValligeId forKey:@"communityId"];
    [para setObject:mBuildId forKey:@"ban"];
    [para setObject:mUnitId forKey:@"unit"];
    [para setObject:mFloor forKey:@"floor"];
    [para setObject:mdoornum forKey:@"roomNumber"];
    [para setObject:mReason forKey:@"complainReason"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/complain/residentsComplaints" parameters:para call:^(mBaseData *info) {
        if (info.mSucess ) {
            
            blovk (info);

        }else{
            blovk (info);

        }
    }];
    
    
}

+ (void)feedCanal:(int)mArearId andName:(NSString *)mName andReason:(NSString *)mReason block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mArearId) forKey:@"communityId"];
    [para setObject:mName forKey:@"staffName"];
    [para setObject:mReason forKey:@"complainReason"];
    [para setObject:@"2" forKey:@"type"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/complain/propertyComplaints" parameters:para call:^(mBaseData *info) {
        if (info.mSucess ) {
            block ( info );
        }else{
            block ( info );
        }
    }];
    
}

- (void)getCanalMsg:(void(^)(mBaseData *resb,GCanalList *mList))block{

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/propertyCost/getPropertyCost" parameters:@{@"userId":[NSString stringWithFormat:@"%d",[mUserInfo backNowUser].mUserId]} call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (info.mSucess) {
            
            GCanalList *mCanal = [[GCanalList alloc] initWithObj:info.mData];
            
            
            for (NSDictionary *dic in mCanal.mList) {
                
                [tempArr addObject:[[GCanal alloc] initWithObj:dic]];
            }
            mCanal.mList = tempArr;
            
            block ( info,mCanal);
            
        }else{
            block ( info,nil);
        }
        
    }];

}

- (void)payCanal:(NSMutableDictionary *)mPara block:(void(^)(mBaseData *resb))block{

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/propertyCost/deliveryCharge" parameters:mPara call:^(mBaseData *info) {
        if (info.mSucess) {
            block ( info );
        }else{
            block ( info );
        }
    }];
    
}


+(void)getCash:(int)mUid andMoney:(NSString *)mMoney andPresentManner:(NSString *)mPresentManner block:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUid) forKey:@"userId"];
    [para setObject:mMoney forKey:@"money"];
    [para setObject:@"0" forKey:@"presentManner"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/wallet/present" parameters:para call:^(mBaseData *info) {
        if (info.mSucess ) {
            
            block ( info );
            
        }else{
            block ( info );
        }
    }];

}

+ (void)getClass:(int)mType block:(void(^)(mBaseData *resb,NSArray *array))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(2) forKey:@"level"];
    [para setObject:NumberWithInt(mType) forKey:@"type"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"classify/getClassify.do" parameters:para call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        if (info.mSucess ) {
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GFix alloc] initWithObj:dic]];

                block(info,tempArr);
            }
            
        }else{
            block(info,nil);

        }
        
    }];
}

+ (void)getFixDetail:(NSString *)mSuperiorId andLevel:(NSString *)mLevel block:(void(^)(mBaseData *resb,NSArray *marr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mSuperiorId forKey:@"superiorId"];
    [para setObject:mLevel forKey:@"level"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/classify/getClassify" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GFix alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
            
        }else{
            block (info,nil);

        }
    }];
}

#pragma mark---提交保修订单
- (void)commitFixOrder:(NSString *)mSuperId andSubClass:(NSString *)mSubClass andNote:(NSString *)mNote andServiceTime:(NSString *)mServiceTime andAddress:(NSString *)mAddress andCommunityId:(NSString *)mCommunityId andServicerId:(int)mId andImgUrl:(NSString *)mImgUrl andVideoUrl:(NSString *)mVideoUrl block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"uid"];
    [para setObject:NumberWithInt(mId) forKey:@"mId"];
    
    [para setObject:mSubClass forKey:@"classification1"];
    [para setObject:mSuperId forKey:@"classification2"];
    [para setObject:mNote forKey:@"remarks"];
    
    [para setObject:mServiceTime forKey:@"appointmentTime"];
    
    [para setObject:[mUserInfo backNowUser].mPhone forKey:@"phone"];
    
    [para setObject:mAddress forKey:@"address"];
    [para setObject:mCommunityId forKey:@"communityId"];
    [para setObject:mImgUrl forKey:@"imageUrl"];
    
    
    if (mVideoUrl) {
        [para setObject:mVideoUrl forKey:@"vidoeUrl"];
    }
    
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/addRepairOrder" parameters:para call:^(mBaseData *info) {
        
        block (info );
        
    }];
    
    
    
}



+ (void)getServiceName:(NSString *)mAddress andLng:(NSString *)mLng andLat:(NSString *)mLat andOneLevel:(NSString *)mOne andTwoLevel:(NSString *)mTwo andPage:(int)mStart andEnd:(int)mEnd block:(void(^)(mBaseData *resb,GServiceList *mList))block{

    NSMutableDictionary *para = [NSMutableDictionary new];

    if (mAddress) {
        [para setObject:mAddress forKey:@"address"];
        
    }else {
        [para setObject:mLng forKey:@"lng"];
        [para setObject:mLat forKey:@"lat"];
    }
    [para setObject:mOne forKey:@"classification1"];
    [para setObject:mTwo forKey:@"classification2"];
    [para setObject:@"1" forKey:@"isAuthentication"];
    [para setObject:NumberWithInt(mStart) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mEnd) forKey:@"pageSize"];


    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/MerchantList" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            GServiceList *GService = [[GServiceList alloc] initWithObj:info.mData];
            
            for (NSDictionary *dic in GService.mArray) {
                
                [tempArr addObject:[[SServicer alloc] initWithObj:dic]];
            }
            GService.mArray = tempArr;
            
            block ( info,GService);
            
        }else{
            block (info, nil );
        }
    }];
    
}


+ (void)getFixOrderComfirm:(int)mOrderId andmId:(int)mId block:(void(^)(mBaseData *resb,GFixOrder *mOrder))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [para setObject:NumberWithInt(mId) forKey:@"mId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/getPreOrder" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {

            block ( info ,[[GFixOrder alloc] initWithObj:info.mData]);
        }else{
            block ( info ,nil);
        }
    }];
}


+ (void)getOrderPaySuccess:(int)mUserId andOrderId:(int)mOrderId block:(void (^)(mBaseData *))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [para setObject:NumberWithInt(mUserId) forKey:@"mId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/reserve" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            block (info);
        }else{
            block (info);
        }
    }];
    
}
+ (void)upDateOrderStatus:(int)mUserId andOrderId:(int)mOrderId block:(void(^)(mBaseData *resb,NSArray *array))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"merchantOrder/modifyOrderWgtStatus.do" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dic in info.mData) {
                
                [tempArr addObject:[[SSellerList alloc]initWithObj:dic]];
            }
            block (info,tempArr);
            
        }else{
            block (info,nil);
        }
    }];
}


- (void)getUserAppointment:(int)mOrderid andSellerId:(int)mSellerId block:(void(^)(mBaseData *resb))block
{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mOrderid) forKey:@"orderId"];
    [para setObject:NumberWithInt(mSellerId) forKey:@"merchantId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"merchant/reserve.do" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
  
            
        }else{
        }
    }];

}


- (void)getSellerMsg:(int)mOid andmId:(int)mId block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mOid) forKey:@"oId"];
    [para setObject:NumberWithInt(mId) forKey:@"mId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"merchantOrder/getOrderInfo.do" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            
            
        }else{
        }
    }];


}

- (void)finishFixOrder:(NSString *)mOrderId andPayType:(NSString *)mPayType andRate:(NSString *)mRate block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mOrderId forKey:@"orderId"];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    
    if (mPayType) {
    [para setObject:mPayType forKey:@"payWay"];
    }
    if (mRate) {
        [para setObject:mRate forKey:@"praiseRate"];
    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/userConfirmation" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            block ( info );
            
        }else{
            block ( info );
        }
    }];
    
    
    
}



- (void)getArear:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/communityCenter/getCommunity" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GArear alloc] initWithObj:dic]];
            }
            block ( info,tempArr );
            
        }else{
            block ( info,nil );
        }
    }];

    
}

- (void)getWallete:(int)mUserID block:(void (^)(mBaseData *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/wallet/walletInfo" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            block ( info );
            
        }else{
            block ( info );
        }
    }];
}
#pragma mark----获取订单列表
- (void)getOrderList:(int)mType block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    NSString *mUrl = nil;
  
    mUrl = @"app/order/countOrderList";
   
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:para call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (info.mSucess) {
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GOrderCount alloc] initWithObj:dic]];
            }
            
            block ( info , tempArr );
            
        }else{
            block ( info , nil );
        }
    }];
 
}

- (void)getOrder:(NSString *)mType andStart:(int)mStart andEd:(int)mEnd block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSString *mUrl = nil;
    
    if ([mType isEqualToString:@"2"]) {
        mUrl = @"app/order/getMobileOrderList";
    }else if ([mType isEqualToString:@"1"]){
        mUrl = @"app/order/getWarrantyOrderList";
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mStart) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mEnd) forKey:@"pageSize"];

    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:para call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (info.mSucess) {
            
            for (NSDictionary *dic in [info.mData objectForKey:@"list"]) {
                [tempArr addObject:[[GFixOrder alloc] initWithObj:dic]];
            }
            
            block ( info , tempArr );
            
        }else{
            block ( info , nil );
        }
    }];

    
    
    
}

- (void)getOrderDetail:(NSString *)mOrderID block:(void(^)(mBaseData *resb,GFixOrder *mFixOrder))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:mOrderID forKey:@"orderId"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:@"ios" forKey:@"device"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/getOrderDetails" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            GFixOrder *mFix = [[GFixOrder alloc] initWithObj:info.mData];
            
            block ( info , mFix );
            
        }else{
            block ( info , nil );
        }
    }];
}


- (void)getShoppingOrderDetail:(int)mOrderID andShopId:(int)shopId type:(kShopType)type block:(void(^)(mBaseData *resb,GShopOrder *mShopOrder))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    //[para setObject:NumberWithInt(shopId) forKey:@"sId"];
    //[para setObject:NumberWithInt(mOrderID) forKey:@"orderId"];
    [para setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%d",mOrderID]] forKey:@"orderId"];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:StringWithInt(type) forKey:@"orderType"];
    [para setObject:@"ios" forKey:@"device"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/shOrder/getShoppingOrderDetails" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
           
            block ( info , [[GShopOrder alloc] initWithObj:info.mData] );
            
        }else{
            block ( info , nil );
        }
    }];
}
#pragma mark----超市订单完成服务
/**
 *  超市订单完成服务
 *
 *  @param mOrderId  订单ID
 *  @param mShopId  店铺id
 *  @param block    返回值
 */
- (void)finishShopOrder:(int)mOrderId andShopId:(int)mShopId type:(kShopType)type block:(void(^)(mBaseData *resb))block;{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:[Util RSAEncryptor:[NSString stringWithFormat:@"%d",mOrderId]] forKey:@"orderId"];
    [para setObject:StringWithInt(type) forKey:@"orderType"];
    [para setObject:@"ios" forKey:@"device"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/shOrder/orderCompletion" parameters:para call:^(mBaseData *info) {
        
        block ( info );
    }];

    
    
}

- (void)getScoreList:(int)mType andPage:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    NSString *mUrl = nil;
    
    if (mType == 1) {
        mUrl = @"app/wallet/getWalletRecordList";
    }else{
        mUrl = @"app/wallet/getIntegralRecord";

    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mNum) forKey:@"pageSize"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:para call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (info.mSucess) {
            
            
            for (NSDictionary *dic in [info.mData objectForKey:@"list"]) {
                
                
                [tempArr addObject:[[GScroe alloc] initWithObj:dic]];
                
            }
            
            block ( info , tempArr );
            
        }else{
            block ( info , nil );
        }
    }];
    
}


- (void)getAddress:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/warrantyOrder/warrantyUserInfo" parameters:para call:^(mBaseData *info) {
        
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (info.mSucess) {
            
            for (NSDictionary *dic in [info.mData objectForKey:@"address"]) {
             
                [tempArr addObject:[[GAddress alloc] initWithObj:dic]];
                
            }
                        
            block ( info ,tempArr);
        }else{
            block ( info ,nil);
        }
        
        
    }];
    
}



+ (void)openPush{

    NSString* t = [NSString stringWithFormat:@"%d", [mUserInfo backNowUser].mUserId];
    
    t = [@"buyer_" stringByAppendingString:t];
    
    //别名
    //1."seller_1"
    //2."buyer_1"
    
    
    //标签
    //1."seller"/"buyer"
    //2."重庆"/...
    
    
    NSSet* labelset = [[NSSet alloc]initWithObjects:@"buyer", @"ios",nil];
    
    [APService setTags:labelset alias:t callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];

}
+ (void)closePush{
    [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];

}

- (void)getCommunityClass:(void(^)(mBaseData *resb,NSArray *mArr))block{

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/newsType/getNewsTypeList" parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                
                [tempArr addObject:[[GCommunityClass alloc] initWithObj:dic]];
                
            }
            block (info,tempArr);
            
        }else{
            
            block (info,nil);
        }
        
    }];
}


#pragma mark----获取社区动态
- (void)getCommunityStatus:(int)mCommunityId andPage:(int)mPage andType:(int)mType block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mCommunityId) forKey:@"communityId"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageIndex"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];
    [para setObject:NumberWithInt(mType) forKey:@"newsType"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/news/getNewSContentList" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {

            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in [info.mData objectForKeyMy:@"list"]) {
                
                [tempArr addObject:[[GCommunityNews alloc] initWithObj:dic]];
                
            }
            
            block (info,tempArr);
        }else{
        
            block (info,nil);
            
        }
        
    }];

    
}

/**
 *  获取新闻详情
 *
 *  @param mNewsId 新闻ID
 *  @param block   返回
 */
- (void)getCommunityDetail:(int)mNewsId block:(void(^)(mBaseData *resb))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mNewsId) forKey:@"id"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/news/getNewSContent" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            
            block (info);
        }else{
            
            block (info);
            
        }
        
    }];
}


#pragma mark----获取地址标签
- (void)getPPTaddressTag:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appSysAddressTag" parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTaddressTag alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
        }else{
            
            block (info,nil);
            
        }
        
    }];

}

#pragma mark----查询常用地址
- (void)getPPTaddressList:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appUserAddrList" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTaddress alloc] initWithObj:dic]];
            }
                       
            block (info,tempArr);
        }else{
            
            block (info,nil);
            
        }
        
    }];


}

#pragma mark----获取附近跑跑腿我想买订单
- (void)getPPTNeaerbyOrder:(int)mType andMlat:(NSString *)mLat andLng:(NSString *)mLng andPage:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    if (mLat) {
        [para setObject:mLat forKey:@"lat"];

    }if (mLng) {
        [para setObject:mLng forKey:@"lng"];

    }
    
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    [para setObject:NumberWithInt(mNum) forKey:@"rows"];

    
    NSString *mUrl = nil;
    
    if (mType == 1) {
        mUrl = @"app/legwork/user/appOrderBuyList";
    }else if (mType == 2){
        mUrl = @"app/legwork/user/appOrderTransactList";
    }else{
        mUrl = @"app/legwork/user/appOrderCarryList";

    }

    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTOrder alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
        }else{
            
            block (info,nil);
            
        }
        
    }];
}


#pragma mark----获取买东西 标签
- (void)getReleaseTags:(int)mType block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    NSString *mUrl = nil;
    
    if (mType == 1) {
        mUrl = @"app/legwork/user/appBuyType";
    }else if (mType == 2){
    
    }else{
        mUrl = @"app/legwork/user/appGoodsType";
    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GReleaseTag alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
        }else{
            
            block (info,nil);
            
        }
        
    }];

}

#pragma mark----添加常用地址
- (void)gPPtaddAddress:(NSString *)mName andSex:(NSString *)mSex andAddress:(NSString *)mAddress andPhone:(NSString *)mPhone andDetailAddress:(NSString *)mDetailAddress andTag:(NSString *)mTag block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:mName forKey:@"userName"];
    [para setObject:mSex forKey:@"sex"];
    [para setObject:mAddress forKey:@"address"];
    [para setObject:mDetailAddress forKey:@"detailsAddr"];
    [para setObject:mPhone forKey:@"phone"];
    [para setObject:mTag forKey:@"addrTagId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appUserAddr" parameters:para call:^(mBaseData *info) {

        if (info.mSucess) {
            block (info );
        }else{
            block (info );
        }
        
    }];


}
#pragma mark----发布跑单
- (void)releasePPTorder:(int)mType andTagId:(NSString *)mTagId andMin:(NSString *)mMin andMAx:(NSString *)mMax andLat:(NSString *)mLat andLng:(NSString *)mLng andContent:(NSString *)mContent andMoney:(NSString *)mMoney andAddress:(NSString *)mAddress andPhone:(NSString *)mPhone andNote:(NSString *)mNote andArriveTime:(NSString *)mTime block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:mContent forKey:@"context"];
    [para setObject:mMoney forKey:@"legworkMoney"];
    [para setObject:mNote forKey:@"comments"];
    [para setObject:mPhone forKey:@"phone"];
    [para setObject:mLng forKey:@"lng"];
    [para setObject:mLat forKey:@"lat"];
    [para setObject:mTime forKey:@"arrivedTime"];
    
    NSString *mUrlStr = nil;
    
    if (mType == 1) {
        mUrlStr = @"app/legwork/user/appOrderBuy";
        
        [para setObject:mMin forKey:@"startPrice"];
        [para setObject:mMax forKey:@"maxPrice"];
        [para setObject:mAddress forKey:@"arrivedId"];
        [para setObject:mTagId forKey:@"orderType"];

    }else if (mType == 2) {
        mUrlStr = @"app/legwork/user/appOrderTransact";
        [para setObject:mAddress forKey:@"address"];


    }else{
        mUrlStr = @"app/legwork/user/appOrderCarry";

    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrlStr parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            block (info );
        }else{
            block (info );
        }
        
    }];
    
    
}


- (void)releasePPTSendorder:(int)mType andTagId:(NSString *)mTagId andMin:(NSString *)mMin andMAx:(NSString *)mMax andLat:(NSString *)mLat andLng:(NSString *)mLng andContent:(NSString *)mContent andMoney:(NSString *)mMoney andAddress:(NSString *)mAddress andPhone:(NSString *)mPhone andNote:(NSString *)mNote andArriveTime:(NSString *)mTime andGoodsName:(NSString *)mGoodsName andGoodsPrice:(NSString *)mGoodsPrice andSendAddress:(NSString *)mSendAddress andArriveAddress:(NSString *)mArriveAddress andTool:(NSString *)mTool block:(void(^)(mBaseData *resb))block{

    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:mGoodsName forKey:@"goodsName"];
    [para setObject:mMoney forKey:@"legworkMoney"];
    [para setObject:mTagId forKey:@"goodsTypeId"];
    [para setObject:mGoodsPrice forKey:@"goodsPrice"];

    [para setObject:mSendAddress forKey:@"sendAddress"];
    [para setObject:mArriveAddress forKey:@"arrivedAddress"];
    [para setObject:mPhone forKey:@"phone"];
    [para setObject:mTool forKey:@"trafficId"];

    [para setObject:mNote forKey:@"comments"];
    [para setObject:mLng forKey:@"lng"];
    [para setObject:mLat forKey:@"lat"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appOrderCarry" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            block (info );
        }else{
            block (info );
        }
        
    }];

}


#pragma mark----获取订单详情
- (void)getOrderDetail:(int)mType andMorderID:(NSString *)mOrderId andOrderCode:(NSString *)mOrderCode block:(void(^)(mBaseData *resb,GPPTOrder *mOrder))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:mOrderId forKey:@"id"];
    [para setObject:mOrderCode forKey:@"orderCode"];
    NSString *mUrlStr = nil;

    if (mType == 1) {

        mUrlStr = @"app/legwork/user/appOrderBuyInfo";

    }else if (mType == 2) {

        mUrlStr = @"app/legwork/user/appOrderTransactInfo";

        
    }else{
        mUrlStr = @"app/legwork/user/appOrderCarryInfo";
        
    }

    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrlStr parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            GPPTOrder *mOrder = [[GPPTOrder alloc] initWithObj:info.mData];
            
            block (info ,mOrder);
        }else{
            block (info ,nil);
        }
        
    }];
}
#pragma mark----获取跑跑腿个人信息
- (void)getPPTPersonMsg:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"legworkUserId"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserInfo" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            
            block (info );
        }else{
            block (info );
        }
        
    }];

    
    
}

- (void)getPPTRoll:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
//    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/rankingList" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in [info.mData objectForKeyMy:@"list"]) {
                [tempArr addObject:[[GPPTRankList alloc] initWithObj:dic]];
            }
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];
}


- (void)getTool:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appTrafficMethod" parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTools alloc] initWithObj:dic]];
            }
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];

}

- (void)getPPTOrderHisTory:(int)mLeft andRight:(int)mRight and:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    [para setObject:NumberWithInt(mNum) forKey:@"rows"];

    NSString *mUrl = nil;
    
    if (mLeft == 1) {
        [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];

        if (mRight == 1) {
            mUrl = @"app/legwork/user/appOrderBuyRecord";
        }else if (mRight == 2){
            mUrl = @"app/legwork/user/appOrderTransactRecord";

        }else{
            mUrl = @"app/legwork/user/appOrderCarryRecord";

        }
    }else{
        [para setObject:NumberWithInt([mUserInfo backNowUser].mLegworkUserId) forKey:@"legId"];

        if (mRight == 1) {
            mUrl = @"app/legwork/user/appOrderBuyLegwrokRecord";
        }else if (mRight == 2){
            mUrl = @"app/legwork/user/appOrderTransactLegwrokRecord";
            
        }else{
            mUrl = @"app/legwork/user/appOrderCarryLegwrokRecord";
            
        }
    }
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:mUrl parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTOrder alloc] initWithObj:dic]];
            }
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];
    
  
}


- (void)applePPT:(NSString *)mName andSex:(NSString *)mSex andPhone:(NSString *)mPhone andIdentify:(NSString *)mIdentify andHandImg:(NSString *)mHandImg andForntImg:(NSString *)mFrontImg andForwordImg:(NSString *)mForwordImg block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];

    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:mName forKey:@"realName"];
    [para setObject:mSex forKey:@"realSex"];
    [para setObject:mPhone forKey:@"realTel"];
    [para setObject:mIdentify forKey:@"cardID"];
    [para setObject:NumberWithFloat(100) forKey:@"money"];
    [para setObject:mHandImg forKey:@"persons"];
    [para setObject:mFrontImg forKey:@"cardFace"];
    [para setObject:mForwordImg forKey:@"cardBack"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/auth/legworkRegUser" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            block (info );
        }else{
            block (info );
        }
        
    }];

    

}
- (void)payPPTAplly:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(100) forKey:@"money"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/auth/depositPay" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            block (info );
        }else{
            block (info );
        }
        
    }];

}

#pragma mark----跑跑腿接单
/**
 *  接单
 *
 *  @param mLegUserId 跑跑腿id
 *  @param mOrderCode 订单编号
 *  @param mOrderType 订单类型
 *  @param mLat       纬度
 *  @param mLng       经度
 *  @param block      返回值
 */
- (void)getPPTOrder:(int)mLegUserId andOrderCode:(NSString *)mOrderCode andOrderType:(NSString *)mOrderType andLat:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb))block{


    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt(mLegUserId) forKey:@"legworkUserId"];
    [para setObject:mOrderCode forKey:@"orderCode"];
    [para setObject:mOrderType forKey:@"orderType"];
    [para setObject:mLat forKey:@"lat"];
    [para setObject:mLng forKey:@"lon"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/order/grabOrder" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            block (info );
        }else{
            block (info );
        }
        
    }];
    
}
#pragma mark----用户取消订单操作
/**
 *  用户取消订单
 *
 *  @param mUserId    用户id
 *  @param mOrderCode 订单编号
 *  @param mOrderType 订单类型
 *  @param mLat       纬度
 *  @param mLng       经度
 *  @param block      返回值
 */
- (void)cancelOrder:(int)mUserId andOrderCode:(NSString *)mOrderCode andOrderType:(int)mOrderType andLat:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb))block{
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mOrderType) forKey:@"orderType"];
    [para setObject:mOrderCode forKey:@"orderCode"];
    
    [para setObject:mLat forKey:@"lat"];
    [para setObject:mLng forKey:@"lon"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appOrderCancel" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            block (info);
            
        }else{
            
            block (info);
        }
    }];
    
    
    
}
#pragma mark----获取系统标签
/**
 *  获取系统标签
 *
 *  @param block 返回值
 */
- (void)getSystemTags:(void(^)(mBaseData *resb,NSArray *mArr))block{

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appSysTag" parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GSystemTags alloc]initWithObj:dic]];
            }
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];
    
    
}


#pragma mark----评价订单
/**
 *  评价订单
 *
 *  @param mUserId    平台用户id
 *  @param mLegId     跑腿用户id
 *  @param mLat       纬度
 *  @param mLng       经度
 *  @param mOrdeCode  订单编号
 *  @param mOrderType 订单类型
 *  @param block      返回值
 */
- (void)rateOrder:(int)mUserId andLegUserId:(int)mLegId andSpeed:(int)mSpeed andMass:(int)mMass andOrderCode:(NSString *)mOrdeCode andOrderType:(int)mOrderType andContent:(NSString *)mContent andTags:(NSString *)mTags block:(void(^)(mBaseData *resb))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];

    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mLegId) forKey:@"legworkUserId"];
    
    [para setObject:mOrdeCode forKey:@"orderCode"];
    [para setObject:NumberWithInt(mOrderType) forKey:@"orderType"];
    
    [para setObject:NumberWithInt(mSpeed) forKey:@"speed"];
    [para setObject:NumberWithInt(mMass) forKey:@"quality"];
    
    [para setObject:mTags forKey:@"tags"];
    [para setObject:mContent forKey:@"content"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appEvaluate" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
         
            
            block (info );
        }else{
            block (info );
        }
        
    }];
    
    
    
}

#pragma mark----获取投诉标签
/**
 *  获取投诉标签
 *
 *  @param block 返回值
 */
- (void)getFeedBackTags:(void(^)(mBaseData *resb,NSArray *mArr))block{
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appTreaty" parameters:nil call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GFeedTags alloc] initWithObj:dic]];
            }
            
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];
    
    
}
#pragma mark----订单投诉
/**
 *  订单投诉
 *
 *  @param mUserId    平台用户id
 *  @param mLegId     跑腿用户id
 *  @param mContent   投诉内容
 *  @param mTagId     理由id
 *  @param mOrderType 订单类型
 *  @param mOrderCode 订单编号
 *  @param mImages    图片组
 *  @param block      返回值
 */
- (void)feedBackOrder:(int)mUserId andLegUserId:(int)mLegId andContent:(NSString *)mContent andFeedTagId:(int)mTagId andOrderType:(int)mOrderType andOrderCode:(NSString *)mOrderCode andImags:(NSString *)mImages block:(void(^)(mBaseData *resb))block{

    
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mLegId) forKey:@"legworkUserId"];
    
    [para setObject:mOrderCode forKey:@"orderCode"];
    [para setObject:NumberWithInt(mOrderType) forKey:@"orderType"];
    
    [para setObject:NumberWithInt(mTagId) forKey:@"treatyId"];
    [para setObject:mContent forKey:@"content"];
    
    if (mImages) {
        [para setObject:mImages forKey:@"url"];
    }
    
    
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appComplaints" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            
            block (info );
        }else{
            block (info );
        }
        
    }];

    
}
#pragma mark----实名认证 获取小区
/**
 *  实名认证 获取小区
 *
 *  @param block 返回值
 */
- (void)getCodeArear:(NSString *)mProvinceId andArearId:(NSString *)mArearId andCityId:(NSString *)mCityId andName:(NSString *)mName andLat:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:mProvinceId forKey:@"provinceId"];
    [para setObject:mArearId forKey:@"cityId"];
    [para setObject:mCityId forKey:@"countyId"];
    
    if (mLat) {
        [para setObject:mLat forKey:@"lat"];
    }
    if (mLng) {
        [para setObject:mLng forKey:@"lng"];
    }
    
    if (mName) {
        [para setObject:mName forKey:@"name"];
    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/communityCenter/verificationCell" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GGetArear alloc] initWithObj:dic]];
            }
            
            block (info ,tempArr);
        }else{
            block (info ,nil);
        }
        
    }];
    
    
    
}

#pragma mark----更新跑跑腿用户状态接口
/**
 *  更新跑跑腿用户状态接口
 *
 *  @param mLat  纬度
 *  @param mLng  经度
 *  @param block 返回值
 */
- (void)ipDataPPTUserStatus:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb))block{
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mLegworkUserId) forKey:@"legworkUserId"];
    
    if (mLat) {
        [para setObject:mLat forKey:@"lat"];
    }
    if (mLng) {
        [para setObject:mLng forKey:@"lng"];
    }
    
    [para setObject:@"1" forKey:@"isOnline"];
    [para setObject:@"1" forKey:@"device"];

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/updateUserState" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            
            block (info );
        }else{
            block (info );
        }
        
    }];

    
}


#pragma mark----获取物管费历史纪录
/**
 *  获取物管费历史纪录
 *
 *  @param block 返回值
 */
- (void)getCanelHistory:(int)mPage block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageIndex"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];

    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/propertyCost/findHistoryPropertyCost" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
        
            
            for (NSDictionary *dic in [info.mData objectForKey:@"propertyCostHistory"]) {
                
                [tempArr addObject:[[GCanal alloc] initWithObj:dic]];
            }

            
            
            block (info,tempArr );
        }else{
            block (info, nil );
            
        }
        
    }];
    
    
}

#pragma mark----获取消息列表
/**
 *  获取消息列表
 *
 *  @param mPage 分页
 *  @param block 返回值
 */
- (void)getMsgList:(int)mPage block:(void(^)(mBaseData *resb,NSArray *mArr))block{

    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
//    [para setObject:NumberWithInt([mUserInfo backNowUser].mSId) forKey:@"serviceId"];
////    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
////    [para setObject:NumberWithInt(10) forKey:@"pageSize"];
//    
//    
//    if ([mUserInfo backNowUser].mIsOpenShop) {
//        [para setObject:NumberWithInt([mUserInfo backNowUser].mShopId) forKey:@"sId"];
//    }
//    if ([mUserInfo backNowUser].mIsOpenMerchant) {
//        [para setObject:NumberWithInt([mUserInfo backNowUser].mId) forKey:@"mId"];
//    }
    
    [para setObject:[Util RSAEncryptor:StringWithInt([mUserInfo backNowUser].mLid )] forKey:@"loginId"];
    [para setObject:NumberWithInt(10) forKey:@"pageSize"];
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:@"ios" forKey:@"device"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"service/serviceMsg/queryServiceMsg" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            
            
            for (NSDictionary *dic in [info.mData objectForKey:@"list"]) {
                
                [tempArr addObject:[[GMsgObj alloc] initWithObj:dic]];
            }
            
            
            
            block (info,tempArr );
        }else{
            block (info, nil );
            
        }
        
    }];
    

    
}


#pragma mark----读消息
/**
 *  读消息
 *
 *  @param mId   消息id
 *  @param block 返回值
 */
- (void)readMsg:(int)mId block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
//    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mId) forKey:@"ids"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/serviceMsg/readMsgInfo" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            block (info );
        }else{
            block (info );
            
        }
        
    }];
    
    
    
}

#pragma mark----删除消息
/**
 *  删除消息
 *
 *  @param mId   消息id
 *  @param block 返回值
 */
- (void)deleteMsg:(int)mId block:(void(^)(mBaseData *resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    
//    [para setObject:NumberWithInt([mUserInfo backNowUser].mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mId) forKey:@"ids"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"service/serviceMsg/deleteMsgInfo" parameters:para call:^(mBaseData *info) {
        
        if (info.mSucess) {
            block (info );
        }else{
            block (info );
            
        }
        
    }];
}


@end

@implementation SMessage

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    
    if( self )
    {
        self.mTitle = [obj objectForKeyMy:@"title"];
        self.mContent = [obj objectForKeyMy:@"content"];
        self.mArgs = [obj objectForKeyMy:@"args"];
        self.mType = [[obj objectForKeyMy:@"type"] intValue];
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];
        self.mIsLook = [[obj objectForKeyMy:@"isLook"] boolValue];
        self.mCreateTime = [obj objectForKeyMy:@"addTime"];
    }
    
    return self;
}

+ (void)getMsgNum:(int)mUserId andIsLook:(int)mIsLook andType:(NSString *)mType block:(void (^)(mBaseData *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mIsLook) forKey:@"isLook"];
    [para setObject:mType forKey:@"type"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"front/personal/informationCount.do" parameters:para call:^(mBaseData *info) {
        if (info.mSucess) {
            
        }else{
        
        }
    }];
}
@end

@implementation SRedBag

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];
    self.mType = [obj objectForKeyMy:@"type"];
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mCreateTime = [obj objectForKeyMy:@"getTime"];
    self.mName = [obj objectForKeyMy:@"nick_name"];
}

@end

@implementation SVerifyMsg


- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{

    self.mCompanyName = [obj objectForKeyMy:@"companyName"];
    self.mVillageName = [obj objectForKeyMy:@"villageName"];
    self.mBuildName = [obj objectForKeyMy:@"buildName"];
    self.mDoorNumber = [obj objectForKeyMy:@"buildNumber"];
    self.mProvince = [obj objectForKeyMy:@"province"];
    self.mCity = [obj objectForKeyMy:@"city"];
    self.cId = [[obj objectForKeyMy:@"cId"] intValue];
    
    
    
    self.mBankCard = [obj objectForKeyMy:@"bankCard"];
    self.mBankName = [obj objectForKeyMy:@"bankName"];
    self.mBankCity = [obj objectForKeyMy:@"bankCity"];
    self.mBankProvince = [obj objectForKeyMy:@"bankProvince"];
    self.mCard = [obj objectForKeyMy:@"card"];
    self.mReal_name = [obj objectForKeyMy:@"real_name"];
    self.mWebsite = [obj objectForKeyMy:@"website"];
    self.mCommunityName = [obj objectForKeyMy:@"communityName"];
    self.mAddr = [obj objectForKeyMy:@"addr"];

    
    
}

@end

@implementation SSellerList

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mSellerName = [obj objectForKeyMy:@"merchantName"];
    self.mSellerPhone = [obj objectForKeyMy:@"merchantPhone"];
    self.mEvolution = [[obj objectForKeyMy:@"praiseRate"] floatValue];
    self.mDistance = [[obj objectForKeyMy:@"distance"] floatValue];
    self.mSellerImg = [obj objectForKeyMy:@"merchantImage"];
    
}

@end
@implementation MBaner

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mImgUrl = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"img"]];
    
    self.mContentUrl = [obj objectForKeyMy:@"url"];
    self.mName = [obj objectForKeyMy:@"name"];
    self.mB_index = [[obj objectForKeyMy:@"b_index"] intValue];
}

@end


@implementation GPPTBaner

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mImgUrl = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"img"]];
    
    self.mContentUrl = [obj objectForKeyMy:@"url"];
    self.mName = [obj objectForKeyMy:@"name"];
    self.mB_index = [[obj objectForKeyMy:@"bIndex"] intValue];
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mVisite = [[obj objectForKeyMy:@"isVisit"] intValue];
    
    self.mUUID = [obj objectForKeyMy:@"uuid"];
    self.mStatus = [[obj objectForKeyMy:@"state"] intValue];
    
    
    
}

@end

@implementation GFix
-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mClassName = [obj objectForKeyMy:@"classificationName"];
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mLevel = [[obj objectForKeyMy:@"level"] intValue];
    self.mSuperID = [[obj objectForKeyMy:@"superiorId"] intValue];
    self.mType = [[obj objectForKeyMy:@"type"] intValue];
    
    self.mDescribe = [obj objectForKeyMy:@"describe"];
    
    
    
    self.mSmallImage = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"minImage"]];
    self.mBigImage = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"maxImage"]];

    self.mEstimatedPrice = [obj objectForKeyMy:@"estimatedPrice"];


}


@end

@implementation SServicer

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mAddress = [obj objectForKeyMy:@"address"];
    
    float distance = [[obj objectForKeyMy:@"distance"] floatValue];
    
    
    
    self.mDistance = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mMerchantName  = [obj objectForKeyMy:@"merchantName"];
    self.mMerchantImage = [obj objectForKeyMy:@"merchantImage"];
    self.mMerchantPhone = [obj objectForKeyMy:@"merchantPhone"];
    self.mPraiseRate = [[obj objectForKeyMy:@"praiseRate"] intValue];

    
    
    
}


@end

@implementation GFixOrder

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    NSMutableArray *mTep = [NSMutableArray new];
    
    for (NSDictionary *dic in [obj objectForKeyMy:@"list"]) {
        [mTep addObject:[[GFixOrderList alloc] initWithObj:dic]];
    }
    
    self.mOrderList = mTep;
    
    self.mTTRow = [[obj objectForKeyMy:@"totalRow"] intValue];
    self.mMerchantID = [[obj objectForKeyMy:@"merchantId"] intValue];
    self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];

    self.mAppointmentTime = [obj objectForKeyMy:@"addTime"];
    self.mBuyerAddress = [obj objectForKeyMy:@"buyerAddress"];
    self.mClassificationName = [obj objectForKeyMy:@"classificationName"];
    self.mMerchantName = [obj objectForKeyMy:@"merchantName"];
    self.mNote = [obj objectForKeyMy:@"description"];
    self.mOrderId = [[obj objectForKeyMy:@"id"] intValue];
    self.mOrderCode = [obj objectForKeyMy:@"orderCode"];
    self.mStatus = [[obj objectForKeyMy:@"status"] intValue];
    self.mPhone = [obj objectForKeyMy:@"phone"];

    self.mAddress = [obj objectForKeyMy:@"addRess"];
    self.mCommunityId = [obj objectForKeyMy:@"communityId"];
    self.mOrderMerchanid = [obj objectForKeyMy:@"merchantId"];
    self.mOrderPrice = [[obj objectForKeyMy:@"price"] floatValue];
    self.mOrderStatus = [obj objectForKeyMy:@"statusName"];
    self.mOrderImage = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"imageUrl"]];
    
    self.mClassificationName2 = [obj objectForKeyMy:@"classificationName2"];
    self.mOrderServiceTime = [obj objectForKeyMy:@"appointmentTime"];
    self.mOrderID = [obj objectForKeyMy:@"id"];
    
    self.addTime = [obj objectForKeyMy:@"addTime"];
    self.mDescription = [obj objectForKeyMy:@"description"];
    self.serviceTime = [obj objectForKeyMy:@"serviceTime"];
  
    self.mVideoUrl = [obj objectForKeyMy:@"videoUrl"];
    self.mEstimatedPrice = [[obj objectForKeyMy:@"estimatedPrice"] floatValue];
    
}

@end

@implementation GArear

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mAddress = [obj objectForKeyMy:@"address"];
    self.mId = [[obj objectForKeyMy:@"id"] intValue];

    
}

@end

@implementation GCity

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mAreaName = [obj objectForKeyMy:@"areaName"];
    self.mAreaId = [obj objectForKeyMy:@"areaId"];
    self.mParentId = [obj objectForKeyMy:@"parentId"];

    
}

@end

@implementation  GCommunity

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mCommunityName = [obj objectForKeyMy:@"communityName"];
    self.mPropertyId = [[obj objectForKeyMy:@"id"] intValue];
    self.mAreaName = [obj objectForKeyMy:@"areaName"];
    
}

@end

@implementation GdoorNum

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mFloor = [obj objectForKeyMy:@"floor"];
    self.mRoomNumber = [obj objectForKeyMy:@"roomNumber"];
    self.mUnit = [obj objectForKeyMy:@"unit"];

    
    
}

@end

@implementation GServiceList


-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mArray = [obj objectForKeyMy:@"merchantList"];
    self.pageSize = [[obj objectForKeyMy:@"pageSize"] intValue];
    self.pageNumber = [[obj objectForKeyMy:@"pageNumber"] intValue];
    
}

@end


@implementation  GCanalList
-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mList = [obj objectForKeyMy:@"propertyCostList"];
    
}


@end

@implementation GCanal

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    
    self.mActualPayment = [[obj objectForKeyMy:@"actualPayment"] floatValue];
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mPaymentUnit = [obj objectForKeyMy:@"paymentUnit"];
    self.mCommunityId = [[obj objectForKeyMy:@"communityId"] intValue];
    self.mDeadline = [obj objectForKeyMy:@"deadline"];
    self.mUserName = [obj objectForKeyMy:@"userName"];
    self.mPayableMoney = [[obj objectForKeyMy:@"payableMoney"] floatValue];
    self.mPaymentAccount = [obj objectForKeyMy:@"paymentAccount"];
    self.mStatus = [[obj objectForKeyMy:@"status"] intValue];
    
    if (self.mStatus == 1) {
        self.mStatustr = @"已支付";
    }else{
        self.mStatustr = @"未支付";
    }
    
    self.mId = [obj objectForKeyMy:@"id"];
    
}

@end

@implementation GOrderCount

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mOrderNum = [obj objectForKeyMy:@"count"];
    self.mOrderType = [obj objectForKeyMy:@"type"];
    self.mOrderName = [obj objectForKeyMy:@"orderTypeName"];
}

@end

@implementation GScroe
-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mAddTime = [obj objectForKeyMy:@"addTime"];
    self.mConsumerId = [obj objectForKeyMy:@"consumerId"];
    self.mDescribe = [obj objectForKeyMy:@"describe"];

    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mPaymentType = [[obj objectForKeyMy:@"paymentType"] intValue];
    self.mScore = [[obj objectForKeyMy:@"score"] intValue];
    self.mType = [[obj objectForKeyMy:@"type"] intValue];
    self.mWid = [[obj objectForKeyMy:@"wid"] intValue];
    self.mRed = [[obj objectForKeyMy:@"red "] intValue];

}


@end

@implementation GCook


-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
  
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mCount = [[obj objectForKeyMy:@"count"] intValue];
    self.mDescription = [obj objectForKeyMy:@"description"];
    self.mFood = [obj objectForKeyMy:@"food"];
    self.mImg = [obj objectForKeyMy:@"img"];
    self.mKeywords = [obj objectForKeyMy:@"keywords"];
    self.mName = [obj objectForKeyMy:@"name"];

    
}
@end

@implementation GAddress

-(id)initWithObj:(NSDictionary*)obj{
    self = [super init];
    if( self )
    {
        [self fetch:obj];
    }
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    

    self.mAddressName = [obj objectForKeyMy:@"userAddress"];
    self.mAddressId = [NSString stringWithFormat:@"%d",[[obj objectForKeyMy:@"communityId"] intValue]];
    
}


@end

@implementation SWxPayInfo
-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        self.mPayType = [obj objectForKeyMy:@"type"];
        self.noncestr = [obj objectForKeyMy:@"nonce_str"];
        self.out_trade_no = [obj objectForKeyMy:@"out_trade_no"];
        self.prepayid = [obj objectForKeyMy:@"prepay_id"];
        self.mtimeStamp = [[obj objectForKeyMy:@"timeStamp"] intValue];
        self.partnerid = [obj objectForKeyMy:@"partnerid"];
        
        self.package = @"Sign=WXPay";
        self.appid = [obj objectForKeyMy:@"appid"];
        
        self.sign = [obj objectForKeyMy:@"sign"];
        
        
        
//        self.sign = [Util getMd5_32Bit:[NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d&key=%@",WXPAYKEY,[obj objectForKeyMy:@"nonce_str"],@"Sign=WXPay",[obj objectForKeyMy:@"partnerid"],[obj objectForKeyMy:@"prepay_id"],[[obj objectForKeyMy:@"timeStamp"] intValue],@"CHAOer68190809PAYCHAOer68190809P"]];
        
        MLLog(@"sig:%@",self.sign);
    }
    return self;
}


@end

@implementation GCommunityClass

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    

    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mName = [obj objectForKeyMy:@"typeName"];
    
}

@end

@implementation GCommunityNews

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mContent = [obj objectForKeyMy:@"content"];
    self.mDateTime = [obj objectForKeyMy:@"dateTime"];
    self.mNewsImage = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"newsImage"]];
    self.mNewTypeId = [[obj objectForKeyMy:@"newsTypeId"] intValue];
    self.mSource = [obj objectForKeyMy:@"source"];
    
    self.mStatus = [[obj objectForKeyMy:@"state"] intValue];
    self.mSubContent = [obj objectForKeyMy:@"subContent"];
    self.mTitel = [obj objectForKeyMy:@"title"];
    self.mTypeName = [obj objectForKeyMy:@"type_name"];
    self.mWriter = [obj objectForKeyMy:@"writer"];
    
    self.mSubTitel = [obj objectForKeyMy:@"subTitle"];
    
}

@end

@implementation GPPTaddress

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mAddress = [obj objectForKeyMy:@"address"];
    self.mAddressName = [obj objectForKeyMy:@"addrName"];
    self.mAlternativePhone = [obj objectForKeyMy:@"alternativePhone"];
    self.mPhone = [obj objectForKeyMy:@"phone"];
    self.mDetailsAddr = [obj objectForKeyMy:@"detailsAddr"];
    self.mUserId = [obj objectForKeyMy:@"userId"];
    self.mUserSex = [obj objectForKeyMy:@"userSex"];
    self.mUserName = [obj objectForKeyMy:@"userName"];


}

@end
#pragma mark----标签对象
@implementation GPPTaddressTag

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTagName = [obj objectForKeyMy:@"addrName"];
    
}


@end

@implementation GReleaseTag

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTagName = [obj objectForKeyMy:@"typeName"];
    self.mTypeName = [obj objectForKeyMy:@"typeName"];
}




@end

@implementation GPPTOrder

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];

    self.mUserId = [obj objectForKeyMy:@"userId"];
    self.mArrivedTime = [obj objectForKeyMy:@"arrivedTime"];
    self.mContext = [obj objectForKeyMy:@"context"];
    self.mDistance = [obj objectForKeyMy:@"distance"];
    self.mGenTime = [obj objectForKeyMy:@"genTime"];
    self.mLegworkMoney = [obj objectForKeyMy:@"legworkMoney"];
    self.mMaxPrice = [obj objectForKeyMy:@"maxPrice"];
    self.mOrderCode = [obj objectForKeyMy:@"orderCode"];
    self.mStartPrice = [obj objectForKeyMy:@"startPrice"];
    self.mAdress = [obj objectForKeyMy:@"address"];
    self.mGoodsName = [obj objectForKeyMy:@"goodsName"];
    self.mGoodsPrice = [obj objectForKeyMy:@"goodsPrice"];
    self.mComments = [obj objectForKeyMy:@"comments"];
    self.mStatusName = [obj objectForKeyMy:@"statusName"];
    
    
    
    self.mPhone = [obj objectForKeyMy:@"phone"];
    self.mPortrait = [obj objectForKeyMy:@"portrait"];
    self.mTypeName = [obj objectForKeyMy:@"typeName"];
    self.mAddrName = [obj objectForKeyMy:@"addrName"];
    self.mSId = [[obj objectForKeyMy:@"sId"] intValue];
    self.mProcessStatus = [[obj objectForKeyMy:@"processStatus"] intValue];
    self.mStatusCommet = [obj objectForKeyMy:@"statusCommet"];
    self.mUserSex = [obj objectForKeyMy:@"userSex"];
    self.mUserName = [obj objectForKeyMy:@"userName"];
    
    int kake = [[obj objectForKeyMy:@"isTake"] intValue];
    
    if (kake == 0) {
        self.mIsTake = NO;
    }else{
        self.mIsTake = YES;
    }
    self.mSendAddress = [obj objectForKeyMy:@"sendAddress"];
    self.mArrivedAddress = [obj objectForKeyMy:@"arrivedAddress"];
    self.mTrafficName = [obj objectForKeyMy:@"trafficName"];
    self.mGoodsTypeName = [obj objectForKeyMy:@"goodsTypeName"];
    self.mPayType = [[obj objectForKeyMy:@"payMethod"] intValue];


}

@end

@implementation GPPTer
static GPPTer *pptuser = nil;
bool pptbined = NO;

+ (GPPTer *)backPPTUser{
    if (pptuser) {
        return pptuser;
    }
    if (pptbined) {
        MLLog(@"警告！递归错误！");
        return nil;
    }
    pptbined = YES;
    @synchronized (self) {
        if (!pptuser) {
            pptuser = [GPPTer loadpptUserInfo];
        }
    }
    pptbined = NO;
    return pptuser;
}
+(GPPTer*)loadpptUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"pptuserInfo"];
    if( dat )
    {
        GPPTer* tu = [[GPPTer alloc]initWithObj:dat];
        return tu;
    }
    return nil;
}

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mUserId = [[obj objectForKeyMy:@"user_id"] intValue];
    self.mPPTerId = [mUserInfo backNowUser].mLegworkUserId;
    self.mLevel = [obj objectForKeyMy:@"user_level"];
    self.mFAQUrl = [obj objectForKeyMy:@"url"];
    self.mName = [obj objectForKeyMy:@"real_name"];
    self.mInfoId = [obj objectForKeyMy:@"info_id"];
    
    self.mRateNum = [obj objectForKeyMy:@"praise_num"];
    
    int mCancel = [[obj objectForKeyMy:@"is_cancel"] intValue];
    if (mCancel == 0) {
        self.mIscancel = NO;
    }else{
        self.mIscancel = YES;
    }
    
    mCancel = [[obj objectForKeyMy:@"is_off"] intValue];
    if (mCancel == 0) {
        self.mIsOff = NO;
    }else{
        self.mIsOff = YES;
    }
    
    
    self.mFeedNum = [obj objectForKeyMy:@"complaints_count"];
    
    self.mHeaderImg = [obj objectForKeyMy:@"portrait"];
    
    self.mTotleMoney = [obj objectForKeyMy:@"pile_money"];
    
    self.mCreateTime = [obj objectForKeyMy:@"gen_time"];
    
    self.mGetOrderNum = [obj objectForKeyMy:@"order_take_num"];
    
    self.mDepositMoney = [obj objectForKeyMy:@"legwork_deposit"];

    
    
    self.mGoodRateCount = [[obj objectForKeyMy:@"high_evaluate"] intValue];
    self.mMidRateCount = [[obj objectForKeyMy:@"medium_evaluate"] intValue];
    self.mBadRatecount = [[obj objectForKeyMy:@"bad_evaluate"] intValue];
    
    
    
    self.mTotleRateCount = self.mBadRatecount + self.mGoodRateCount + self.mMidRateCount;

    
    self.mPhone =[obj objectForKeyMy:@"phone"];
    
}
- (BOOL)isVaildpptUser{
    return YES;
}

+ (void)getPPTerInfo:(int)mUserId block:(void (^)(mBaseData *resb, GPPTer *mUser))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUser" parameters:para call:^(mBaseData *info) {
        
        [self dealpptUserSession:info block:block];
    }];

    
}
+(void)dealpptUserSession:(mBaseData*)info block:(void(^)(mBaseData* resb, GPPTer*user))block{

#warning 返回的数据是整个用户信息对象
    if ( info.mSucess || info.mState == 200011) {
        NSDictionary* tmpdic = info.mData;
        
        NSMutableDictionary* tdic = [[NSMutableDictionary alloc]initWithDictionary:info.mData];
        
        GPPTer* tu = [[GPPTer alloc]initWithObj:tdic];
        tmpdic = tdic;
        if ([tu isVaildpptUser]) {
            [GPPTer savepptUserInfo:tmpdic];
            pptuser = nil;
            
        }
        
        
        
    }
    
    
    block( info , [GPPTer backPPTUser] );
}
+(void)savepptUserInfo:(NSDictionary *)dccat{
    dccat = [Util delNUll:dccat];
    
    NSMutableDictionary *dcc = [[NSMutableDictionary alloc] initWithDictionary:dccat];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:dcc forKey:@"pptuserInfo"];
    
    
    
    [def synchronize];
}

- (void)getPPTBaseUserInfo:(void(^)(mBaseData* resb, GPPTUserInfo*user))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserInfo" parameters:para call:^(mBaseData *info) {
        
        block (info ,[[GPPTUserInfo alloc] initWithObj:info.mData]);
    }];
}

- (void)getPPTMsgList:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData* resb, NSArray*mArr))block{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mNum) forKey:@"pageSize"];

    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserMsg" parameters:para call:^(mBaseData *info) {
        

        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in [info.mData objectForKey:@"list"]) {
                [tempArr addObject:[[GPPTMsgInfo alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
            
        }else{
        
            block (info,nil);
        }
    }];

}


- (void)getPPTTotleMoney:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData* resb, NSArray*mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    
    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mNum) forKey:@"pageSize"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserPile" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in [info.mData objectForKeyMy:@"list"]) {
                [tempArr addObject:[[GPPTReward alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
            
        }else{
            
            block (info,nil);
        }
    }];
}
- (void)getPPTRateList:(int)mType andPage:(int)mPage andNum:(int)mNum block:(void(^)(mBaseData* resb, NSArray*mArr))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    [para setObject:NumberWithInt(mType) forKey:@"type"];

    [para setObject:NumberWithInt(mPage) forKey:@"pageNumber"];
    [para setObject:NumberWithInt(mNum) forKey:@"pageSize"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserEvaluate" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in [info.mData objectForKey:@"list"]) {
                [tempArr addObject:[[GPPTRateList alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
            
        }else{
            
            block (info,nil);
        }
    }];
    
}

- (void)getMyTags:(void(^)(mBaseData* resb, NSArray*mArr))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/queryUserTags" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (NSDictionary *dic in info.mData) {
                [tempArr addObject:[[GPPTMyTag alloc] initWithObj:dic]];
            }
            
            block (info,tempArr);
            
        }else{
            
            block (info,nil);
        }
    }];
}
/**
 *  注销身份
 *
 *  @param block 返回值
 */
- (void)cancelPPTIdentify:(void(^)(mBaseData* resb))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/cancel" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
  
            block (info);
            
        }else{
            
            block (info);
        }
    }];
    
}


- (void)pptDeleteMessages:(NSString *)mMessageIds block:(void(^)(mBaseData *resb))block{


    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt([GPPTer backPPTUser].mPPTerId) forKey:@"legworkUserId"];
    [para setObject:mMessageIds forKey:@"ids"];
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/user/deleteUserMsg" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            block (info);
            
        }else{
            
            block (info);
        }
    }];
    
    
    
    
}

#pragma mark----确认完成订单
/**
 *  确认完成订单
 *
 *  @param mOrderCode 订单编号
 *  @param mOrderType 订单类型
 *  @param mLat       纬度
 *  @param mLng       经度
 *  @param block      返回值
 */
- (void)finishPPTOrder:(int)mUserId andOrderCode:(NSString *)mOrderCode andOrderType:(int)mOrderType andLat:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mUserId) forKey:@"userId"];
    [para setObject:NumberWithInt(mOrderType) forKey:@"orderType"];
    [para setObject:mOrderCode forKey:@"orderCode"];

    [para setObject:mLat forKey:@"lat"];
    [para setObject:mLng forKey:@"lon"];
    
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/user/appComfirmOrder" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            block (info);
            
        }else{
            
            block (info);
        }
    }];
    
    
}

#pragma mark----跑腿者确认订单
/**
 *  确认完成订单
 *
 *  @param mOrderCode 订单编号
 *  @param mOrderType 订单类型
 *  @param mLat       纬度
 *  @param mLng       经度
 *  @param block      返回值
 */
- (void)mServicefinishPPTOrder:(int)mUserId andMoney:(int)mMoney andOrderCode:(NSString *)mOrderCode andOrderType:(int)mOrderType andLat:(NSString *)mLat andLng:(NSString *)mLng block:(void(^)(mBaseData *resb))block{


    
    NSMutableDictionary *para = [NSMutableDictionary new];
    
#pragma mark----发布者传userid  跑腿者传legid
    
    [para setObject:NumberWithInt(mUserId) forKey:@"legworkUserId"];
    [para setObject:NumberWithInt(mOrderType) forKey:@"orderType"];
    [para setObject:mOrderCode forKey:@"orderCode"];
    
    [para setObject:mLat forKey:@"lat"];
    [para setObject:mLng forKey:@"lon"];
    
    
    if (mOrderType == 1) {
        [para setObject:NumberWithInt(mMoney) forKey:@"money"];
    }
    
    [[HTTPrequest sharedHDNetworking] postUrl:@"app/legwork/service/order/confirmOrder" parameters:para call:^(mBaseData *info) {
        
        
        if (info.mSucess) {
            
            block (info);
            
        }else{
            
            block (info);
        }
    }];
    
    
    

}

@end
@implementation GPPTUserInfo
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mLevel = [[obj objectForKeyMy:@"level"] intValue];
    self.mPile = [[obj objectForKeyMy:@"pile"] intValue];
    self.mCardID = [obj objectForKeyMy:@"cardID"];
    
    self.mComplaints = [[obj objectForKeyMy:@"complaints"] intValue];
    
    self.mName = [obj objectForKeyMy:@"name"];
    
    int sex = [[obj objectForKeyMy:@"sex"] intValue];
    if (sex == 0) {
        self.mSex = @"女";
    }else{
        self.mSex = @"男";
    }
    

    
    self.mDeposit = [[obj objectForKeyMy:@"deposit"] intValue];
    
    self.mOrders = [obj objectForKeyMy:@"orders"];
    
    self.mTel = [obj objectForKeyMy:@"tel"];
    
    self.mGen_time = [obj objectForKeyMy:@"gen_time"];
    
    self.mPraise = [obj objectForKeyMy:@"praise"];
    
    
    
}



@end
@implementation GPPTRankList

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mLevel = [[obj objectForKeyMy:@"user_level"] intValue];
    
    self.mName = [obj objectForKeyMy:@"real_name"];
    
    int sex = [[obj objectForKeyMy:@"real_sex"] intValue];
    if (sex == 0) {
        self.mSex = @"女";
    }else{
        self.mSex = @"男";
    }
    
    self.mId = [[obj objectForKeyMy:@"user_id"] intValue];
    
    self.mHeaderImg = [obj objectForKeyMy:@"portrait"];
    
    
    self.mTel = [obj objectForKeyMy:@"real_tel"];
    
    self.mOrderNum = [[obj objectForKeyMy:@"order_take_num"] intValue];
    
    self.mTags = [obj objectForKeyMy:@"tags"];
}


@end

@implementation GPPTMyTag
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mTagNum = [[obj objectForKeyMy:@"count"] intValue];
    
    self.mTagName = [obj objectForKeyMy:@"tag_name"];

}


@end

@implementation GPPTReward

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mOrderType = [[obj objectForKeyMy:@"order_type"] intValue];
    
    self.mPileMoney = [[obj objectForKeyMy:@"pile_money"] intValue];
    
    self.mGenTime = [obj objectForKeyMy:@"gen_time"];
    self.mPileTitle = [obj objectForKeyMy:@"pile_title"];
    self.mOrderCode = [obj objectForKeyMy:@"order_code"];

}


@end

@implementation GPPTMsgInfo


- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mMsgType = [[obj objectForKeyMy:@"msg_type"] intValue];
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    
    self.mGenTime = [obj objectForKeyMy:@"gen_time"];
    self.mContent = [obj objectForKeyMy:@"msg_content"];
    self.mTitle = [obj objectForKeyMy:@"msg_title"];
    
}
@end

@implementation GPPTools
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];

    self.mToolName = [obj objectForKeyMy:@"trafficName"];
    
}


@end

@implementation GPPTRateList

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mService_efficiency = [[obj objectForKeyMy:@"service_efficiency"] intValue];
    self.mService_satisfaction = [[obj objectForKeyMy:@"service_satisfaction"] intValue];
    
    self.mContent = [obj objectForKeyMy:@"evaluate_context"];
    self.mNickName = [obj objectForKeyMy:@"nick_name"];
    self.mGenTime = [obj objectForKeyMy:@"gen_time"];

    
}

@end

@implementation GSystemTags

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{

    self.mTagId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTagName = [obj objectForKeyMy:@"sysTagName"];
    
}

@end

@implementation GFeedTags

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mTagId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTagName = [obj objectForKeyMy:@"title_alias"];
    
}

@end

@implementation GCodeProvince
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mProvinceId = [[obj objectForKeyMy:@"provinceId"] intValue];
    self.mProvinceName = [obj objectForKeyMy:@"provinceName"];

    
    NSMutableArray *tempArr = [NSMutableArray new];
    
    for (NSDictionary *dic in [obj objectForKeyMy:@"cityList"]) {
        [tempArr addObject:[[GCodeArear alloc] initWithObj:dic]];
    }
    self.mProvinceArr = tempArr;

    
}


@end
@implementation GCodeArear
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mArearId = [[obj objectForKeyMy:@"cityId"] intValue];
    self.mArearName = [obj objectForKeyMy:@"cityName"];
    
    NSMutableArray *tempArr = [NSMutableArray new];
    
    for (NSDictionary *dic in [obj objectForKeyMy:@"countyList"]) {
        [tempArr addObject:[[GCodeCity alloc] initWithObj:dic]];
    }
    self.mArearArr = tempArr;
    
    
}


@end
@implementation GCodeCity
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mCityId = [[obj objectForKeyMy:@"countyId"] intValue];
    self.mCityName = [obj objectForKeyMy:@"countyName"];
    self.mCityCode = [obj objectForKeyMy:@"countyJianpin"];
    
}


@end

@implementation GGetArear

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mArearName = [obj objectForKeyMy:@"areaName"];
    self.mName = [obj objectForKeyMy:@"communityName"];
    self.mDistance = [obj objectForKeyMy:@"distance"];

}

@end


@implementation GMsgObj
-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    
    self.mIsRead = [[obj objectForKeyMy:@"isRead"] boolValue];
    self.mType = [[obj
                   objectForKeyMy:@"type"] intValue];
    self.mMsg_title = [obj objectForKeyMy:@"msgTitle"];
    self.mMsg_content = [obj objectForKeyMy:@"msgContent"];
    self.mGen_time = [obj objectForKeyMy:@"addtime"];
    
    
    self.mExtras = [[GExtra alloc] initWithObj:[Util dictionaryWithJsonString:[obj objectForKeyMy:@"extras"]]];
    
    

}


@end

@implementation GExtra
-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    
    self.mOrderType = [obj objectForKeyMy:@"order_type"];
    
    self.mModel = [obj objectForKeyMy:@"model"];
    
    self.mPlaformtType = [[obj objectForKeyMy:@"type"] intValue];
    
    self.mOrderCode = [obj objectForKeyMy:@"order_code"];
    
    self.mUrl = [obj objectForKeyMy:@"url "];
    
    
    
}

@end
#pragma mark----认证地址对象
/**
 *  认证地址对象
 */
@implementation GAddArearObj

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    NSMutableArray *mUniArr = [NSMutableArray new];
    
    NSArray *mArr = [obj objectForKeyMy:@"umitList"];
    
    
    for (NSDictionary *dic in mArr) {
        
        GArearUnitAndFloorObj *mUnitObj = [[GArearUnitAndFloorObj alloc]initWithObj:dic];
        
        [mUniArr addObject:mUnitObj];
    }
    
    self.mUnitList = mUniArr;
    
    self.mBan = [[obj objectForKeyMy:@"ban"] intValue];

    
}

@end

@implementation GArearUnitAndFloorObj

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    
    self.mUnit = [[obj objectForKeyMy:@"unit"] intValue];
    self.mRoomNum = [[obj objectForKeyMy:@"room_number"] intValue];
    self.mFloor = [[obj objectForKeyMy:@"floor"] intValue];

    
}

@end

@implementation GTradeHistory

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    
    self.mOldMoney = [[obj objectForKeyMy:@"beforeMoney"] floatValue];
    self.mNewMoney = [[obj objectForKeyMy:@"afterMoney"] floatValue];
    self.mNowMoney = [[obj objectForKeyMy:@"txMoney"] floatValue];

    self.mOutMoney = [[obj objectForKeyMy:@"txType"] floatValue];
    self.mNote = [obj objectForKeyMy:@"txResult"];
    self.mTime = [obj objectForKeyMy:@"addTime"];

    
}

@end


@implementation GFixOrderList


-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    self.mAddTime = [obj objectForKeyMy:@"addTime"];
    
    self.mPhone = [obj objectForKeyMy:@"phone"];

    self.mMerchantID = [[obj objectForKeyMy:@"merchantId"] intValue];

    self.mDescrip = [obj objectForKeyMy:@"description"];

    self.mOrderCode = [obj objectForKeyMy:@"orderCode"];
    
    self.mPrice = [[obj objectForKeyMy:@"price"] floatValue];

    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    
    self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];
    
    self.mState = [[obj objectForKeyMy:@"status"] intValue];
    
    
    self.mUserName = [obj objectForKeyMy:@"userName"];
    
    self.mAddress = [obj objectForKeyMy:@"addRess"];
    
    self.mServiceName = [obj objectForKeyMy:@"classificationName"];


    
    
}
@end

@implementation GShopOrder
-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    self.mUserId = [[obj objectForKeyMy:@"userId"] intValue];

    self.mPayTime = [obj objectForKeyMy:@"payTime"];
    
    int mRate = [[obj objectForKeyMy:@"isComment"] intValue];
    
    self.mIscoment = mRate?1:0;
    
    self.mPhone = [obj objectForKeyMy:@"tel"];

    self.mConsignee = [obj objectForKeyMy:@"consignee"];
    
    self.mUserName = [obj objectForKeyMy:@"userName"];

    
    self.mCommodityPrice = [[obj objectForKeyMy:@"commodityPrice"] floatValue];
    
    self.mDistributionMode = [obj objectForKeyMy:@"distributionMode"];
    
    self.mAddTime = [obj objectForKeyMy:@"addTime"];
    
    self.mShopId = [[obj objectForKeyMy:@"shopId"] intValue];
    
    self.mCount = [[obj objectForKeyMy:@"count"] intValue];

    self.mShopName = [obj objectForKeyMy:@"shopName"];
    
    self.mPayableAmount = [[obj objectForKeyMy:@"payableAmount"] intValue];

    self.mState = [[obj objectForKeyMy:@"state"] intValue];

    self.mOrderCode = [obj objectForKeyMy:@"orderCode"];
    
    self.mShopLogo = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"shopLogo"]];

    self.mDeliverFee = [[obj objectForKeyMy:@"deliverFee"] floatValue];
    
    self.mAddTime = [obj objectForKeyMy:@"addTime"];
    
    self.mAmountMoney = [[obj objectForKeyMy:@"amountMoney"] floatValue];
    
    self.mDistributionAddress = [obj objectForKeyMy:@"distributionAddress"];
    
    self.mOrderId = [[obj objectForKeyMy:@"orderId"] intValue];
    
    
    self.mCardRollId = [[obj objectForKeyMy:@"cardRollId"] intValue];
    
    self.mDistributionTime = [obj objectForKeyMy:@"distributionTime"];
    self.mRemarks = [obj objectForKeyMy:@"remarks"];
    
    
    self.mCreditPrice = [[obj objectForKeyMy:@"creditPrice"] floatValue];
    
    self.mCouponMoney = [[obj objectForKeyMy:@"couponMoney"] floatValue];
    
    int mInter = [[obj objectForKeyMy:@"integral"] intValue];
    
    self.mIntegral = mInter?1:0;
    
    
    NSMutableArray *mTempGoods = [NSMutableArray new];
    
    for (NSDictionary *dic in [obj objectForKeyMy:@"merchbillList"]) {
        [mTempGoods addObject:[[GGoods alloc] initWithObj:dic]];
    }
    
    self.mGoodsArr = mTempGoods;


}


@end

@implementation GGoods

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
   
    
    self.mNumber = [[obj objectForKeyMy:@"number"] intValue];
    
    self.mUnitPrice = [[obj objectForKeyMy:@"unitPrice"] floatValue];
    
    self.mTotalPrice = [[obj objectForKeyMy:@"totalPrice"] floatValue];
    
    self.mGoodsName = [obj objectForKeyMy:@"goodsName"];
    
    self.mGoodsImg = [NSString stringWithFormat:@"%@%@",[HTTPrequest currentResourceUrl],[obj objectForKeyMy:@"goodsImg"]];

    self.mRemarks = [obj objectForKeyMy:@"remarks"];
    
    self.mGoodsComment = [obj objectForKeyMy:@"goodsComment"];

    
}

@end

@implementation GShopList

-(id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
    
}
- (void)fetchIt:(NSDictionary *)obj{
    
    
    self.mType = [[obj objectForKeyMy:@"type"] intValue];
    
    self.mSid = [[obj objectForKeyMy:@"sId"] intValue];
    
    NSString *mSS = nil;
    
    switch (self.mType) {
        case 1:
        {
            mSS = @"超市";
        }
            break;
        case 2:
        {
            mSS = @"餐饮";
        }
            break;
        case 3:
        {
            mSS = @"干洗";
        }
            break;
            
        default:
            break;
    }
    
    self.mCategry = mSS;
    
}

@end