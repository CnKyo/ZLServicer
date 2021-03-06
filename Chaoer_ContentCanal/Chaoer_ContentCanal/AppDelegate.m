//
//  AppDelegate.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MTA.h"
#import "MTAConfig.h"

#import "JPUSHService.h"

#import "WebVC.h"
#import "ViewController.h"


#import "QUCustomDefine.h"
#import "APIObjectDefine.h"
#import "UIViewController+QUAdditions.h"
#import "HomeNewVC.h"
#import "marketOrderViewController.h"
#import "fixViewController.h"
#import "PushAudioPlayer.h"


@interface AppDelegate ()<UIAlertViewDelegate>

@end
@interface myalert : UIAlertView

@property (nonatomic,strong) id obj;

@end

@implementation myalert


@end
@implementation AppDelegate
{
    UIViewController* _theshop;
}
-(void)initExtComp
{
    [MAMapServices sharedServices].apiKey = AMAP_KEY;
    [AMapSearchServices sharedServices].apiKey = AMAP_KEY;
    [AMapLocationServices sharedServices].apiKey = AMAP_KEY;
    [MTA startWithAppkey:@"IBW9PAI485ZQ"];


}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.

    [self initExtComp];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                   UIRemoteNotificationTypeSound |
//                                                   UIRemoteNotificationTypeAlert)
//                                       categories:nil];
//    
//    
//    [APService setupWithOption:launchOptions];
    

    [mUserInfo openPush];
    
    
    [self dealFuncTab];
//    if ([application
//         
//         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        
//        //注册推送, iOS 8
//        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings
//                                                
//                                                settingsForTypes:(UIUserNotificationTypeBadge |
//                                                                  
//                                                                  UIUserNotificationTypeSound |
//                                                                  
//                                                                  UIUserNotificationTypeAlert)
//                                                
//                                                categories:nil];
//        
//        [application registerUserNotificationSettings:settings];
//        
//    } else {
//        
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
//        
//        UIRemoteNotificationTypeAlert |
//        
//        UIRemoteNotificationTypeSound;
//        
//        [application registerForRemoteNotificationTypes:myTypes];
//        
//    }
    
   
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if( notificationPayload )
    {
#warning push->notification
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:notificationPayload forKey:@"push"];
        
        [defaults synchronize];

        [self performSelector:@selector(pushView:) withObject:notificationPayload afterDelay:1.0f];
         
    }
    return YES;
}

- (void)pushView:(NSDictionary *)dic{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notify"object:dic];

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
}
- (void)redirectNSlogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [self performSelector:@selector(ddddoti:) withObject:nil afterDelay:1];
}

-(void)ddddoti:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMsg" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(void)gotoLogin
//{
//    UINavigationController* navvc = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
//    
//    if( [navvc.topViewController isKindOfClass:[ViewController class]] )
//    {
//        return;
//    }
//    
//    
////    [SUser logout];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    id viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
//    
//    [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:viewController animated:YES];
//}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    MLLog(@"reg push err:%@",error);
}
#pragma mark*-*----加载推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    //[APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        
        [self dealPush:userInfo bopenwith:NO];
    }
    else
    {
        [self dealPush:userInfo bopenwith:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self application:application didReceiveRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

-(void)dealPush:(NSDictionary*)userinof bopenwith:(BOOL)bopenwith
{
    NSLog(@"userinof: %@", userinof);
    JPushReceiveObject *it = [JPushReceiveObject mj_objectWithKeyValues:userinof];
    
    if( !bopenwith ) {
        if (it.aps.alert.length>0) {
            
            if (it.aps.sound.length>0 && ![it.aps.sound isEqualToString:@"default"]) {
                [[PushAudioPlayer sharedClient] play:it.aps.sound];
            }
            
            myalert *alertVC = [[myalert alloc]initWithTitle:@"提示" message:it.aps.alert delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
            alertVC.obj = it;
            [alertVC show];
        }

    } else {
        [self goToVCWithPush:it];
    }
    
    
//    SMessageInfo* pushobj = [[SMessageInfo alloc]initWithAPN:userinof];
    
    if( !bopenwith )
    {//当前用户正在APP内部,,
//        myalert *alertVC = [[myalert alloc]initWithTitle:@"提示" message:@"有新的消息是否查看?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
////        alertVC.obj = pushobj;
//        [alertVC show];
    }
    else
    {
        
//        if( pushobj.mType == 1 )
//        {
//            myMessageViewController* vc = [[myMessageViewController alloc]init];
//            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
//        }
//        else if( pushobj.mType == 2 )
//        {
//            WebVC* vc = [[WebVC alloc]init];
//            vc.mName = @"详情";
//            vc.mUrl = pushobj.mArgs;
//        }
//        else if( pushobj.mType == 3 )
//        {
//            orderDetail* vc = [[orderDetail alloc]initWithNibName:@"orderDetail" bundle:nil];
//            vc.mtagOrder = SOrder.new;
//            vc.mtagOrder.mId = [pushobj.mArgs intValue];
//            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
//        }
    }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    MLLog(@"tag:%@ alias%@ irescod:%d",tags,alias,iResCode);
    if( iResCode == 6002 )
    {
//        [SUser  relTokenWithPush];
        [mUserInfo openPush];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[PushAudioPlayer sharedClient] stop];
    
    if (alertView.tag == 10000) {
        
        if (buttonIndex == 0) {
            [mUserInfo logOut];
            [self gotoLogin];

        }
    }else{
        if (buttonIndex == 1) {
            JPushReceiveObject* pushobj = ((myalert *)alertView).obj;
            
            [self goToVCWithPush:pushobj];
            
            //        SMessageInfo* pushobj = ((myalert *)alertView).obj;
            
            //        if( pushobj.mType == 1 )
            //        {
            //            myMessageViewController* vc = [[myMessageViewController alloc]init];
            //            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
            //        }
            //        else if( pushobj.mType == 2 )
            //        {
            //            WebVC* vc = [[WebVC alloc]init];
            //            vc.mName = @"详情";
            //            vc.mUrl = pushobj.mArgs;
            //        }
            //        else if( pushobj.mType == 3 )
            //        {
            //
            //            orderDetail *order = [[orderDetail alloc] initWithNibName:@"orderDetail" bundle:nil];
            //            SOrder *s = [[SOrder alloc] init];
            //            s.mId = [pushobj.mArgs intValue];
            //            order.mtagOrder = s;
            //            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:order animated:YES];
            //        }
            //
        }
        
    }
}
-(void)gotoLogin
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    UINavigationController* nownav = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
    
    UIViewController* vcvc = [nownav topViewController];
    
    if( [vcvc isKindOfClass:[ViewController class]] )
    {//如果顶层是 LoginVC 就不去了
        
    }
    else
    {
        //这里还处理一个事情,就是退出登陆,,要把无效的token,去除..
        
        [mUserInfo logOut];
        [vcvc presentViewController:viewController animated:YES completion:nil];
        
    }
}

-(void)goToVCWithPush:(JPushReceiveObject *)item
{
    UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
    NSArray *arr = navVC.viewControllers;
    
    if (arr.count > 0) {
        if (arr.count == 1) {
            
            if ([mUserInfo backNowUser] != nil) {
                HomeNewVC *vc = [[HomeNewVC alloc] init];
                [navVC pushViewController:vc animated:NO];
                [vc performSelector:@selector(jPusthVCWithType:) withObject:item.order_type afterDelay:0.1];
            }
        } else if (arr.count == 2){
            UIViewController *vc = [arr objectAtIndex:1];
            [vc performSelector:@selector(jPusthVCWithType:) withObject:item.order_type afterDelay:0.1];
        } else {
            NSMutableArray *arrNew = [NSMutableArray array];
            [arrNew addObject:[arr objectAtIndex:0]];
            [arrNew addObject:[arr objectAtIndex:1]];
            [navVC setViewControllers:arrNew animated:NO];
            
            UIViewController *vc = [arr objectAtIndex:1];

            [vc performSelector:@selector(jPusthVCWithType:) withObject:item.order_type afterDelay:0.1];
        }
    }

}



-(void)dealFuncTab
{
    
//    UITabBarController* rootvc = (UITabBarController*)self.window.rootViewController;
//    if( ![SUser currentUser].isSeller )
//    {
//        NSMutableArray* a = [NSMutableArray arrayWithArray: rootvc.viewControllers];
//        if( a.count == 4 )
//        {
//            _theshop = [a objectAtIndex:2];
//            [a removeObjectAtIndex:2];
//            [rootvc setViewControllers:a animated:YES];
//        }
//    }
//    else
//    {
//        NSMutableArray* a = [NSMutableArray arrayWithArray: rootvc.viewControllers];
//        if( a.count == 2 )
//        {
//            [a insertObject:_theshop atIndex:3];
//            [rootvc setViewControllers:a animated:YES];
//        }
//    }
    
}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    

}



@end
