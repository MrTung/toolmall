//
//  DTLongLinkBusiness.h
//  APLongLinkService
//
//  Created by alipay\kuohai on 14-9-8.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SyncNetType)
{
    SyncNetTypeAvailable = 0,//Sync可用
    SyncNetTypeNotAvailable  //Sync不可用
    
};

typedef NS_ENUM(NSInteger, SyncBizType)
{
    SyncBizTypeUser = 0,//User类型用户
    SyncBizTypeDevice  //Device类型用户
    
};

typedef NS_ENUM(NSInteger,NetConnectType)
{
    NetConnectTypeNotAvailable = 0, //当前网络不可用
    NetConnectTypeConnecting,       //连接中
    NetConnectTypeConnected,        //连接上
    NetConnectTypeConnectFailed     //连接失败
};

typedef NS_ENUM(NSInteger,NetReceivingStatus)
{
    NetReceivingStatusReceivingData = 1, //收取中
    NetReceivingStatusNoData,       //没有数据
};

//监听通知
extern NSString * const APConnectionStatusNotification;
//Notification status info key
extern NSString * const APConnectionStatusKey;
//Sync带Push通知
extern NSString * const APSyncPushDataNotification;
//收取中的通知
extern NSString * const APReceivingStatusNotification;
extern NSString * const APReceivingStatusKey;

@interface DTLongLinkBusiness : NSObject

/**
 *	@brief	通用业务通过传送appid得到应该监听的长连接消息
 *
 *	@param 	appId 	注册appId
 *
 *	@return 消息字符串
 */
+ (NSString *)longLinkNotifyWithAppId:(NSString *)appId;

/**
 *	@brief	老业务获取监听的长连接消息
 *
 *	@param 
 *
 *	@return 消息字符串
 */
+ (NSString *)longLinkNotifyUserInfoKey;

/**
 *	@brief	发送消息
 *
 *	@param 	data 	发送内容
 *	@param 	biz 	发送方
 *
 *	@return	void
 */
+ (void)sendMessage:(NSDictionary *)data biz:(NSString *)biz;

/**
 *	@brief	注册SyncBizTypeUser业务 （注册业务接口调用前需要注册业务通知来监听长连接通道发送过来的业务消息）
 *
 *	@param 	biz 	业务名称
 *
 *	@return	void
 */
+ (void)registerBiz:(NSString *)biz;

/**
 *	@brief	注册SyncBizTypeUser业务并立即同步 （注册业务接口调用前需要注册业务通知来监听长连接通道发送过来的业务消息）
 *
 *	@param 	biz 	业务名称
 *
 *	@return	void
 */
+ (void)registerBizAndSync:(NSString *)biz;

/**
 *	@brief	取消业务注册
 *
 *	@param 	biz 	业务名称
 *
 *	@return	void
 */
+ (void)unRegisterBizStopSync:(NSString *)biz;

/**
 *	@brief	消息处理完成通知通道层
 *
 *	@param 	dic 	返回处理消息信息
 *
 *	@return
 */
+ (void)responseMessageNotify:(NSDictionary *)dic;

/**
 *	@brief	全量刷新
 *
 *	@param 	biz 	业务名称
 *s
 *	@return
 */
+ (void)totalRefreshBiz:(NSString *)biz;

/**
 *	@brief	业务方通知更新本地和服务端同步点
 *
 *	@param 	biz 	业务名称
  *	@param 	sKey 	业务方从服务端取回的同步点
 *
 *	@return
 */
+ (void)refreshSkey:(NSString *)biz sKey:(NSString *)sKey;

/**
 *	@brief	业务方通知更新本地和服务端同步点
 *
 *	@param 	biz 	业务名称
 *
 *	@return
 */
+ (NSString *)getBizSkey:(NSString *)biz;

/**
 *	@brief	查询业务是否注册上报成功并可用
 *
 *	@param 	biz 	业务名称
 *
 *	@return	返回业务是否理解可用状态
 *          SyncNetTypeAvailable   可用
 *          SyncNetTypeNoAvailable 不可用
 */
+ (SyncNetType)querySyncNetType:(NSString *)biz;

/**
 *  Sync是否可用
 *  当连接建立成功，并且发出init包收到了服务端的init回复后表示可用,否则不可用
 *
 *  @return YES(可用)/NO(不可用)
 */
+ (BOOL)isSyncAvailable;
/**
 *	网络连接状态
 */
+(NetConnectType)connectStatus;
/**
 *  通知SyncSDK已经注册通知监听,可以接收Sync消息
 *  如果不调用该接口则不分发Sync消息,消息会积压在SyncSDK的数据库
 *  @param 	biz 	业务名称
 *  @return 调用成功或者失败YES/NO
 */
+(BOOL)hasRegisterNotificationWithBiz:(NSString*)biz;
@end
