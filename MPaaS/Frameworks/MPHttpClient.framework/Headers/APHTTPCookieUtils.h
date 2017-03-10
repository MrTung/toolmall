//
//  APHTTPCookieUtils.h
//  APMobileNetwork
//
//  Created by WenBi on 13-9-13.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APHTTPCookie;
@class DTRpcConfig;

@interface APHTTPCookieUtils : NSObject

+ (NSArray *)cookiesFromString:(NSString *)string;
+ (APHTTPCookie *)cookieFromString:(NSString *)string;
//存储重用cookie
+(void)saveCookie:(NSString*)tag;
//设置重用cookie
+(NSInteger)setReadCookie:(DTRpcConfig *)cfg;
//删除重用cookie
+(void)removeReuseCookie;
@end
