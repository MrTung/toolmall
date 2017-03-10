//
//  DTLongLinkControl.h
//  APLongLinkService
//
//  Created by alipay\kuohai on 14-9-14.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

//降级开关
#define AP_LONGLINK_DOWNGRAGE_CONFIG @"AP_LONGLINK_DOWNGRAGE_CONFIG"
extern NSString * const APLongLinkErrorNotification;

@interface DTLongLinkControl : NSObject

+ (DTLongLinkControl *)sharedInstance;

/**
 *	@brief	设置初始化参数
 *
 *	@param 	url 	    url
 *	@param 	port 	    端口
 *	@param 	appName 	客户端名称
 *	@param 	appVersion 	客户端版本
 *
 *	@return
 */
- (void)setDirectAsyncURL:(NSString *)url port:(NSInteger)port appName:(NSString *)appName appVer:(NSString *)appVersion;

/**
 *	@brief  设置id。无id可不设置。
 *
 *	@param 	did 	utdid
 *	@param 	tid 	移动快捷tid
 *
 *	@return
 */
- (void)setDid:(NSString *)did tid:(NSString *)tid;

/**
 *	@brief	获取当前设备当前应用唯一id，用于消息指定设备推送
 *
 *	@return	cdid
 */
- (NSString *)getCdid;

/**
 *	@brief	创建业务内长连接，初始化设备数据
 *
 *	@return
 */
- (void)createAsyncSocket;

/**
 *	@brief	断开长连接
 *
 *	@return
 */
- (void)closeAsyncSocket;

/**
 *	@brief	用户登陆初始化业务内长连接数据
 *
 *	@param 	userId 	    用户名
  *	@param 	sessionId   用于校验session合法性
 *
 *	@return
 */
- (void)sendBindUser:(NSString *)userId sessionId:(NSString *)sessionId;

/**
 *	@brief	解绑当前连接用户
 *
 *	@return
 */
- (void)sendUnBindUser;

@end
