//
//  Util.m
//  WeiDianApp
//
//  Created by zzl on 14/12/5.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import "CustomDefine.h"
#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "keyChain.h"
#import "sys/utsname.h"

#import "RSAEncryptor.h"

@implementation Util

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (BOOL)checkNum:(NSString *)numStr{

    if( [self isPureInt:numStr] || [self isPureFloat:numStr]){
        
        return YES;
        
    }
    return NO;
}


+(BOOL)checkSFZ:(NSString *)numStr
{
    if( numStr == nil || [numStr length] != 18 )
    {
        return NO;
    }
    
    char string_idnum[19];  // 身份证号码，最后一位留空，一会算出来最后一位
    
    char verifymap[] = "10X98765432";  // 加权乘积求和除以11的余数所对应的校验数
    
    int factor[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1};  // 加权因子
    
    long sum = 0l;  //加权乘积求和
    
    int m = 0;  // 加权乘积求和的模数
    
    char * p = string_idnum;  // 当前位置
    
    memset(string_idnum, 0, sizeof(string_idnum));  // 清零
    
    const char* snum = [numStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    strcpy(string_idnum, snum);  // 本体码，也就是前17位
    string_idnum[17] = '\0';
    
    while(*p)  // 在 '\0' 之前一直成立
        
    {
        
        sum += (*p - '0') * factor[p - string_idnum];  // 加权乘积求和
        
        p++;  // 当前位置增加1
        
    }
    
    m = sum % 11;  // 取模
    
    return verifymap[m] == snum[17];
}
+(NSDate*)dateWithInt:(double)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}
+(NSString*)getTimeStringPointSecond:(double)second//2015.06.18. 12:12:00
{
    return [Util getTimeStringPoint:[Util dateWithInt:second]];
}
+(NSString*)getTimeStringHourSecond:(double)second
{
    return [Util getTimeStringHour: [Util dateWithInt:second] ];
}

+(NSString *)dateForint:(double)time bfull:(BOOL)bfull
{
    NSDate *date = [Util dateWithInt:time];
   return [Util getTimeString:date bfull:bfull];
}
+(NSString*)getTimeString:(NSDate*)dat bfull:(BOOL)bfull
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSString *strDate = [dateFormatter stringFromDate:dat];
    if( bfull ) return strDate;
    
  //  NSString *nodatetring = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+ (NSString *)DateTimeInt:(int)time{
    
    NSDate *date = [Util dateWithInt:time];
    NSString *timeStr = [Util getTimeString:date bfull:NO];
    
    
    NSString *ss = timeStr;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[Util dateWithInt:time]];
    NSInteger wkd = [comps weekday];
    
    NSString* wdkstr = @"";
    switch (wkd) {
        case 1:
            wdkstr = @"日";
            break;
        case 2:
            wdkstr = @"一";
            break;
        case 3:
            wdkstr = @"二";
            break;
        case 4:
            wdkstr = @"三";
            break;
        case 5:
            wdkstr = @"四";
            break;
        case 6:
            wdkstr = @"五";
            break;
        case 7:
            wdkstr = @"六";
            break;
        default:
            break;
    }
    NSString *month = [NSString stringWithFormat:@"%@月%@日\n%@",sm,sd,wdkstr];
    return month;

    
}
+(NSString*)getTimeStringWithP:(double)time
{
    NSDate *date = [Util dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString*)getTimeStringHour:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringNoYear:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringS:(NSDate*)dat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:dat];
}
+(NSString*)getTimeStringSS:(NSDate*)dat   //date转字符串 20150415
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:dat];
}


+(NSString*)getTimeStringPoint:(NSDate*)dat   //date转字符串 2015.03.23 08:00:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString *) FormartTime:(NSDate*) compareDate 
{
    
    if( compareDate == nil ) return @"";
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = timeInterval;
    NSString *result;
    
    if (timeInterval < 60) {
        if( temp == 0 )
            result = @"刚刚";
        else
            result = [NSString stringWithFormat:@"%d秒前",(int)temp];
    }
    else if(( timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",(int)temp/60];
    }
    
    else if(( temp/86400) <30){
        
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"dd"];
        NSString *str = [date stringFromDate:[NSDate date]];
        int nowday = [str intValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        int day = [strDate intValue];
        if (nowday-day==0) {
            [dateFormatter setDateFormat:@"今天 HH:mm"];
            result =    [dateFormatter stringFromDate:compareDate];
        }
        else if(nowday-day==1)
        {
            
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            result =  [dateFormatter stringFromDate:compareDate];
            
            
        }
        
        
        else if( temp < 8 )
        {
            if (temp==1) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            else if(temp == 2)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"前天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:compareDate];
            result = strDate;
            
        }
    }
    else
    {//超过一个月的就直接显示时间了
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        result = strDate;
    }
    
    /*
     else if((temp = (temp/(3600*24))/30) <12){
     result = [NSString stringWithFormat:@"%d个月前",(int)temp];
     }
     else{
     temp = temp/12;
     result = [NSString stringWithFormat:@"%d年前",(int)temp];
     }
     */
    
    return  result;
}


+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW //缩放图片,,最大多少
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    
    if( org.size.width > maxW )
    {
        w = maxW;
        h = (w / org.size.width) * org.size.height;
    }
    else
    {
        w = org.size.width;
        h = org.size.height;
        return org;
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}

//缩放图片
+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    if( org.size.width > org.size.height )
    {
        if( org.size.width > maxsize )
        {
            w = maxsize;
            h = (w / org.size.width) * org.size.height;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    else
    {
        if( org.size.height > maxsize )
        {
            h = maxsize;
            w = (h / org.size.height) * org.size.width;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//相对布局 base基准控件 dif间隔距离 tag要移动的控件 tagatdic tag在base的哪个位置
+(void)relPosUI:(UIView*)base dif:(CGFloat)dif tag:(UIView*)tag tagatdic:(RelDic)dic
{
    CGRect bf = base.frame;
    CGRect f = tag.frame;
    if( base != tag.superview )
    {
        switch ( dic ) {
            case E_dic_l:
                f.origin.x = bf.origin.x - dif - f.size.width;
                break;
            case E_dic_r:
                f.origin.x = bf.origin.x + bf.size.width + dif;
                break;
            case E_dic_t:
                f.origin.y = bf.origin.y - f.size.height  - dif;
                break;
            case E_dic_b:
                f.origin.y = bf.origin.y + bf.size.height + dif;
                break;
            default:
                break;
        }
        
        tag.frame = f;
    }
    else
    {//如果是基于父view
        switch ( dic ) {
            case E_dic_l:
                f.origin.x = dif;
                break;
            case E_dic_r:
                f.origin.x = bf.size.width - f.size.width - dif;
                break;
            case E_dic_t:
                f.origin.y = bf.size.height - f.size.height - dif;
                break;
            case E_dic_b:
                f.origin.y = dif;
                break;
            default:
                break;
        }
        
        tag.frame = f;
    }
    
}
+(void)autoExtendH:(UIView*)tagview dif:(CGFloat)dif
{//寻找所有子view,最底部的那个
    
    CGFloat offset = 0.0f;
    BOOL b = NO;
    for( UIView* one in tagview.subviews )
    {
        if( one.hidden ) continue;
        b = YES;
        CGFloat t   = one.frame.origin.y + one.frame.size.height;
        offset = t > offset ? t :offset;
    }
    
    if( !b ) return;
    
    CGRect f = tagview.frame;
    f.size.height = offset + dif;
    tagview.frame = f;
}
+(void)autoExtendH:(UIView*)tagview blow:(UIView*)subview dif:(CGFloat)dif
{
    CGRect f = tagview.frame;
    
    f.size.height = subview.frame.origin.y + subview.frame.size.height + dif;
    
    tagview.frame = f;
}



+(BOOL)checkPasswdPre:(NSString *)passwd
{
    if (passwd.length<6||passwd.length>20) {
        return NO;
    }
    return YES;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{

    if (mobileNum.length <= 0)
    {
        return NO;
    }
    
    NSString *phoneRegex = @"\\b(1)[34578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}

+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

+ (BOOL)checkBankCard:(NSString*)bankCard{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[bankCard length];
    int lastNum = [[bankCard substringFromIndex:cardNoLength-1] intValue];
    
    bankCard = [bankCard substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [bankCard substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5_16:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0+4], result[1+4], result[2+4], result[3+4],
            result[4+4], result[5+4], result[6+4], result[7+4]
            ];
}

+ (NSString *)md5_16Max:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0+4], result[1+4], result[2+4], result[3+4],
            result[4+4], result[5+4], result[6+4], result[7+4]
            ];
    
}


+(void)md5_16_b:(NSString*)str outbuffer:(char*)outbuffer
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    memcpy(outbuffer, &result[4], 8);
}

+ (NSString *)getMd5_32Bit:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, 32, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    return result;
}
+(NSDictionary*)delNUll:(NSDictionary*)dic
{
    NSArray* allk = dic.allKeys;
    NSMutableDictionary* tmp = NSMutableDictionary.new;
    for ( NSString* onek in allk ) {
        id v = [dic objectForKey:onek];
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp setObject:ta forKey:onek];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp setObject:td forKey:onek];
            continue;
        }
        [tmp setObject:v forKey:onek];
    }
    return tmp;
}
+(NSArray*)delNullInArr:(NSArray*)arr
{
    NSMutableArray* tmp = NSMutableArray.new;
    for ( id v in arr ) {
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp addObject:ta];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp addObject:td];
            continue;
        }
        [tmp addObject:v];
    }
    return tmp;
}

+(UIColor*)stringToColor:(NSString*)str
{
    if( str.length != 7 ) return nil;
    //#54fd13
    NSString* r = [str substringWithRange:NSMakeRange(1, 2)];
    unsigned long rv = strtoul( [r UTF8String] , NULL, 16);
    
    NSString* g = [str substringWithRange:NSMakeRange(3, 2)];
    unsigned long gv = strtoul( [g UTF8String] , NULL, 16);
    
    NSString* b = [str substringWithRange:NSMakeRange(5, 2)];
    unsigned long bv = strtoul( [b UTF8String] , NULL, 16);
    
    return ColorRGB(rv,gv,bv);
}

+(NSString*)getDistStr:(int)dist
{
    if( dist < 1000 )
        return [NSString stringWithFormat:@"%dm",dist];
    else if( dist < 1000*100 )
        return [NSString stringWithFormat:@"%dkm",dist/1000];
    else
        return @">100km";
}

//MARK: sign
+ (NSString *)genWxSign:(NSDictionary *)signParams parentkey:(NSString*)parentkey
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    [sign appendFormat:@"key=%@",parentkey];
    
    return  [[Util md5:sign] uppercaseString];
}

//MARK: sign
+ (NSString *)genWXClientSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    return [Util sha1:signString];;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}


//requrl http://api.fun.com/getxxxx
//
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param
{
    if( param.count == 0 ) return requrl;
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"%@=%@&",onek,param[onek]];
    }
    return [NSString stringWithFormat:@"%@?%@",requrl,[reqstr substringToIndex:reqstr.length-2]];
}

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    [reqstr appendString:@"<xml>\n"];
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"<%@>%@</%@>\n",onek,param[onek],onek];
    }
    [reqstr appendString:@"</xml>"];
    return reqstr;
}

+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}



/*
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

*/

+(int)gettopestV:(int)v
{
    int r = v;
    while ( r > 10 )
    {
        r  = r/10;
    }
    return r;
}


+(NSString*)URLEnCode:(NSString*)str
{
    NSString *resultStr = str;
    
    CFStringRef originalString = (__bridge CFStringRef) str;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+(NSString*)URLDeCode:(NSString*)str
{
    return [[str      stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//20150416 => 4月16日
+(NSString*)convdatestr:(NSString*)str
{
    if( str.length == 8 )
    {
        NSString* m = [str substringWithRange:NSMakeRange(4, 2)];
        NSString* d = [str substringWithRange:NSMakeRange(6, 2)];
    
        return [NSString stringWithFormat:@"%@月%@日",m,d];
    }
    return str;
}


+ (NSString *)startTimeStr:(NSString *)startTime andEndTime:(NSString *)endTime{
    NSString *ss = startTime;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    NSString *s2 = [a objectAtIndex:1];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSArray *startTimeH = [s2 componentsSeparatedByString:@":"];
    NSString *sh = [startTimeH objectAtIndex:0];
    NSString *sc = [startTimeH objectAtIndex:1];
    
    NSString *LsTime = [NSString stringWithFormat:@"%@/%@ %@:%@",sm,sd,sh,sc];
    
    
    
    NSString *sss = endTime;
    NSArray *a1 = [sss componentsSeparatedByString:@" "];
    NSString *s3 = [a1 objectAtIndex:0];
    NSString *s4 = [a1 objectAtIndex:1];
    
    NSArray *endTimeY = [s3 componentsSeparatedByString:@"-"];
    NSString *em = [endTimeY objectAtIndex:1];
    NSString *ed = [endTimeY objectAtIndex:2];
    
    NSArray *endTimeH = [s4 componentsSeparatedByString:@":"];
    NSString *eh = [endTimeH objectAtIndex:0];
    NSString *ec = [endTimeH objectAtIndex:1];
    
    NSString *LeTime = [NSString stringWithFormat:@"%@/%@ %@:%@",em,ed,eh,ec];
    
    NSString *TT = [NSString stringWithFormat:@"%@-%@",LsTime,LeTime];
    return TT;
}
+ (NSString *)startTimeStr:(NSString *)startSS{
    
    if (startSS.length == 0) {
        return startSS;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date2 =  [dateFormatter dateFromString:startSS];
    
    
    NSString* dateNow;
    dateNow = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *date1 = [dateFormatter dateFromString:dateNow];
    
    if ([date1 isEqualToDate:date2]) {
        return @"今天";
    }
    else if ([[date1 dateByAddingTimeInterval:86400] isEqualToDate:date2]) {
        return @"明天";
    }
    else if ([[date1 dateByAddingTimeInterval:86400*2]isEqualToDate:date2])
    {
        return @"后天";
    }else{
    return [[startSS substringFromIndex:6] stringByAppendingString:@"号"];
    }
    
}

+ (CGFloat)labelText:(NSString *)s fontSize:(NSInteger)fsize labelWidth:(CGFloat)width{
    UIFont *font = [UIFont systemFontOfSize:fsize];
    CGSize size  = CGSizeMake(width,2000);
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGSize labelsize    = CGSizeZero;
    if (systemVersion >= 7.0){
        NSDictionary *tdic =  [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        labelsize = [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }else {
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelsize.height;
}
+ (NSString *)mFirstStr:(NSString *)mFirstStr andSecondStr:(NSString *)secondStr{

    NSString *ss = mFirstStr;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    NSString *s2 = [a objectAtIndex:1];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSString *month = [NSString stringWithFormat:@"%@月%@日",sm,sd];
    
    NSString *ss8 = secondStr;
    NSArray *ssss1 = [ss8 componentsSeparatedByString:@" "];
    NSString *s20 = [ssss1 objectAtIndex:1];
    
    NSString *tt = [NSString stringWithFormat:@"%@ %@-%@",month,s2,s20];
    
    return tt;

}
+ (int)mTimeToInt:(NSDate *)dateStr{

    int finalitime = [[NSString stringWithFormat:@"%f",[dateStr timeIntervalSince1970]]intValue]-3600*8;
    return finalitime;
}
+ (NSString *)mDuration:(int)Duration{

    int hour =  Duration/3600;
    int munite = Duration/60%60;
    
    int mm = Duration/60;
    
    NSString *str = nil;
    if (mm >= 60) {
        str = [NSString stringWithFormat:@"%d小时%d分钟",hour,munite];
    }
    if (mm<=60) {
        str = [NSString stringWithFormat:@"%d分钟",munite];
    }

    return str;
}
+(NSMutableAttributedString *)labelWithUnderline:(NSString *)mString{
    NSMutableAttributedString *phoneStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", mString]];
    NSRange phoneRange = {0,[phoneStr length]};
    [phoneStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:phoneRange];
    return phoneStr;
}


+ (NSString *)mStartTimeArr:(NSArray *)Sarr andmEndTimeArr:(NSArray *)Earr{

    NSMutableArray  *tempArr = [NSMutableArray new];

    for (int i = 0;i<Sarr.count;i++) {
        NSString *string = [NSString stringWithFormat:@"%@-%@",Sarr[i],Earr[i]];
        [tempArr addObject:string];

    }
    NSString *ArrStr = [NSString stringWithFormat:@"%@",tempArr];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()"];
     ArrStr = [[ArrStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
    MLLog(@"/-------------%@---------------/",ArrStr);
    return ArrStr;
}
+ (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
///时间date转时间戳
+ (int)DateToInt:(NSString *)date{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"HH:mm"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    NSLog(@"date = %@", inputDate);
    
    int finalitime = [[NSString stringWithFormat:@"%f",[inputDate timeIntervalSince1970]]intValue];
    return finalitime;

}

///2个时间比较大小
+ (NSDate *)CompareTime:(NSString *)mTimeStr{

    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm"];
    NSDate* date1 = [formater dateFromString:mTimeStr];
    NSLog(@"第一个时间：%@", date1);
    return date1;

}
+ (NSString *)getAPPName{
    
    NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];

    return AppName;

}
+ (NSString *)getAppSchemes{
    NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
    
    NSString *str = nil;
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSDictionary *dic in [dict objectForKey:@"CFBundleURLTypes"]) {
       str  = [dic objectForKey:@"CFBundleURLSchemes"];
        [tempArr addObject:str];
    }
    return tempArr[0];
}



+ (NSString *)getDeviceModel{    
    
//    NSString* phoneModel = [[UIDevice currentDevice] model];
//
//    return phoneModel;
    
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    else{
    
        deviceString = @"ipad";
    }
    return deviceString;
    
}

+ (NSString *)getDeviceVersion{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];

    return versionNum;
}

#pragma mark----获取设备build号
/**
 *  获取设备build号
 *
 *  @return 返回字符串
 */
+ (NSString *)getAPPBuildNum{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    
    return versionNum;
    
}

+(NSString *)getDeviceUUID{
    NSString * strUUID = (NSString *)[keyChain load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [keyChain save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (CGFloat)labelTextWithWidth:(NSString *)str{
    CGSize strsize = [str sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    return strsize.width;
    
}
+ (CGSize)boundingRectWithSize:(CGSize)size andStr:(NSString *)str
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


+ (BOOL)isHaveIllegalChar:(NSString *)str{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSRange range = [str rangeOfCharacterFromSet:doNotWant];
    return range.location<str.length;
}
#pragma mark----过滤emoji表情
/**
 *  过滤emoji表情
 *
 *  @param string 传入字符串
 *
 *  @return 返回过滤后的字符串
 */
+ (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

#pragma mark----RSA加密
/**
 *  RSA加密
 *
 *  @param mText 加密内容
 *
 *  @return 返回加密内容
 */
+ (NSString *)RSAEncryptor:(NSString *)mText{

    RSAEncryptor* rsaEncryptor = [[RSAEncryptor alloc] init];
    NSString* publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSString* privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    [rsaEncryptor loadPublicKeyFromFile: publicKeyPath];
    [rsaEncryptor loadPrivateKeyFromFile: privateKeyPath password:@"chaoer168"];    // 这里，请换成你生成p12时的密码
    NSString *mEncryptorStr = [rsaEncryptor rsaEncryptString:mText];

    NSLog(@"加密: %@", mEncryptorStr);       // 请把这段字符串Copy到JAVA这边main()里做测试
    NSString* decryptString = [rsaEncryptor rsaDecryptString:mEncryptorStr];
    NSLog(@"揭秘: %@", decryptString);

    return mEncryptorStr;
    
}

@end







