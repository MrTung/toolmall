//
//  AppDelegate.m
//  eshop
//
//  Created by mc on 15/10/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AppDelegate.h"

#import "UIView+FontSize.h"
#import "PageScroll.h"
#import "CountMemberRequest.h"
#import "CountMemberService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"
//#import "WechatAuthSDK.h"
#import "UMMobClick/MobClick.h"
//#import "UncaughtExceptionHandler.h"
#import "Bugly.h"

//#import "JSPatchPlatform/JSPatch.h"
#import "UMSocialCore.h"
#import "UMSocialQQHandler.h"

#import <CloudPushSDK/CloudPushSDK.h>
#import <UserNotifications/UserNotifications.h>
#import "AppMessage.h"


#import "MTControllerChooseTool.h"

@interface AppDelegate ()<WXApiDelegate, UNUserNotificationCenterDelegate>
{
    UNUserNotificationCenter *center;
}
@end

@implementation AppDelegate
//@synthesize catProdList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UIView setIgnoreTags:@[@1111]];
    
    [[DynamicReleaseInterface sharedInstance] executeLocalBandage:DRLocalBandageExecutionAll];
    
    self.showUrl = NO;
    
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57f98f37e0f55a174f001ce6"];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxc4fc78ed1d8fabc0" appSecret:@"86193c380d21c5dbdd3e2a49ef2df66d" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101275767"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [MTControllerChooseTool chooseRootViewController];
    
#pragma mark - 友盟渠道统计
    
    UMConfigInstance.appKey = @"57f98f37e0f55a174f001ce6";
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    // 异常信息收集
    [Bugly startWithAppId:@"b2e3d724a9"];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"%d", [SESSION getSession].uid]];
    /**
     *  卡顿监控-3.0 S
     */
    BuglyConfig *buglyConfig = [[BuglyConfig alloc] init];
    buglyConfig.blockMonitorEnable = YES;
    buglyConfig.blockMonitorTimeout = 3.0;
    
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    //     [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    [self initCloudPush];
    [self registerAPNS:application];
    [self registerMessageReceive];
    
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    //    [self createCustomNotificationCategory];
    
    return YES;
}

- (void) initMainWindow{
    
    [self increaseCountActive];
    
}

//记录激活量和日活量
- (void)increaseCountActive{
    UIDevice *myDevice = [[UIDevice alloc]init];
    CountMemberRequest *request = [[CountMemberRequest alloc] init];
    request.session = [SESSION getSession];
    request.imei =[myDevice uniqueAppInstanceIdentifier];
    CountMemberService *service = [[CountMemberService alloc] init];
    [service increaseActive:request];
}

//心跳服务，记录用户停留时间
+ (void)startHeartBeatService{
    NSThread *heartBeatService = [[NSThread alloc] initWithTarget:self selector:@selector(heartBeatServiceEntryPoint:) object:nil];
    [heartBeatService start];
}

+ (void)heartBeatServiceEntryPoint:(id)__unused object {
    
    CountMemberService *service = [[CountMemberService alloc] init];
    UIDevice *myDevice = [[UIDevice alloc]init];
    NSString *imei = [myDevice uniqueAppInstanceIdentifier];
    
    do {
        [NSThread sleepForTimeInterval:30]; // 间隔30s
        [service heatBeatRequest:imei];
    } while (YES);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            
            if ([resultStatus isEqualToString:@"9000"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"1"];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"0"];
            }
        }];
        NSLog(@"installed--");
    }
    return result;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                //                NSString *memo = [resultDic objectForKey:@"memo"];
                //                NSString *result = [resultDic objectForKey:@"result"];
                
                if ([resultStatus isEqualToString:@"9000"]){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"1"];
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"0"];
                }
            }];
        }
        return YES;
    }
    if (result) {
        
        if ([url.host isEqualToString:@"pay"]) {
            [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    return result;
}


#pragma mark - 微信支付回调函数

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            case WXErrCodeUserCancel:
                /**< 用户点击取消并返回    */
                NSLog(@"支付失败");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

#pragma mark - 腾讯bugly回调

- (NSString *)attachmentForException:(NSException *)exception {
    
    return @"上传至服务器";
}


#pragma mark - 阿里 云推送
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"23605759" appSecret:@"8e8c33b8b33b6375062cd996b3014e3f" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    //    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        //        center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                [application registerForRemoteNotifications];
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    }
}

/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}


/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    
    AppMessage *msgModel = [[AppMessage alloc] init];
    msgModel.title = title;
    msgModel.content = body;
    [[TextDataBase shareTextDataBase] saveAppMessage:msgModel];
    
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

#pragma mark- 通知处理 iOS 10↓
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    //    application.applicationIconBadgeNumber = 0;
    
    
    AppMessage *msgModel = [[AppMessage alloc] init];
    //    msgModel.title = title;
    msgModel.title = content;
    [[TextDataBase shareTextDataBase] saveAppMessage:msgModel];
    
    //    NSString *push = [userInfo valueForKey:@"push"];
    
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

#pragma mark- 通知处理 iOS 10↑

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *contentTitle = [aps valueForKey:@"alert"];
    AppMessage *msgModel = [[AppMessage alloc] init];
    //    msgModel.title = title;
    msgModel.title = contentTitle;
    [[TextDataBase shareTextDataBase] saveAppMessage:msgModel];
    
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知相关字段信息
    [self handleiOS10Notification:notification];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    // 通知弹出，且带有声音、内容和角标（App处于前台时不建议弹出通知）
    //    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    
    completionHandler();
}

@end
