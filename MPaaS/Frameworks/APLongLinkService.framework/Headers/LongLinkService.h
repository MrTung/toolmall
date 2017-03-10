//
//  LongLinkService.h
//  APLongLinkService
//
//  Created by alipay\kuohai on 14-9-15.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>


//兼容老版本接口
@interface LongLinkService : NSObject

+ (LongLinkService *)sharedInstance;

/*
 * 业务通过传送appid得到应该监听的长连接消息
 */
- (NSString *)longLinkNotifyWithAppId:(NSString *)appId;

/*
 * 长连接通知
 */
@property(nonatomic, strong, readonly) NSString * longLinkNotifyUserInfoKey;

@end
