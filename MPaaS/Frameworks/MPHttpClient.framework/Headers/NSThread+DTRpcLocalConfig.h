//
//  NSThread+DTRpcLocalConfig.h
//  APMobileNetwork
//
//  Created by WenBi on 13-4-18.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTRpcConfig;

/*
 * 扩展一个 \code NSThread 的类别，用于线程本地存储。
 */
@interface NSThread (DTRpcLocalConfig)

/*
 * 当前线程中的 RPC 配置对象。
 */
@property(nonatomic, strong) DTRpcConfig *localRpcConfig;

/*
 * 临时的 RPC 配置对象。
 */
@property(nonatomic, strong) DTRpcConfig *temporaryRpcConfig;

@end
