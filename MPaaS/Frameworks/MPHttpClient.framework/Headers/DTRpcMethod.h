//
//  DTRpcMethod.h
//  APMobileNetwork
//
//  Created by WenBi on 13-4-18.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RpcCacheDataType)
{
    RpcCacheDataTypeDefault = 0,//不存储RPC数据,不读取RPC的cache数据,普通的RPC流程
    RpcCacheDataTypeCommonSave, //RPC完成后保存数据为普通数据,与userId无关
    RpcCacheDataTypeUserSave,   //RPC完成后保存数据为用户数据,当前userId是存数据的Key的一部分
    RpcCacheDataTypeCommonRead, //不做网络请求,根据RPC参数为从cache中读取数据,无数据返回nil,与登录无关
    RpcCacheDataTypeUserRead,   //不做网络请求,根据RPC参数和userId为从cache中读取数据,不是登录态时或无数据返回nil
};

@interface DTRpcMethod : NSObject

/** Operation type */
@property(nonatomic, copy) NSString *operationType;

/** 期望返回的对象类型。*/
@property(nonatomic, unsafe_unretained) Class resultClass;

/** 返回对象的类型。 */
@property(nonatomic, copy) NSString *returnType;

/** 如果一个 PRC 方法的返回值是一个集合类型，\code elementClass 指定集合中元素的类型。否则该属性为 nil。*/
@property(nonatomic, unsafe_unretained) Class elementClass;

/** 检查登录 */
@property(nonatomic, assign) BOOL checkLogin;

/** 签名 */
@property(nonatomic, assign) BOOL signCheck;

/** 是否是统一账户网关的请求，默认NO*/
@property(nonatomic, assign) BOOL isAliUserGWMethod;

/** 统一账户网关需要在httpHeader里加此字段*/
@property(nonatomic, strong) NSString *apdid;

/** 缓存策略 */
@property(nonatomic, assign) RpcCacheDataType cacheStrategy;

/** 是否支持网络层的重传,需要业务做好幂等性才设置为YES */
@property(nonatomic, assign) BOOL retryable;

/** rpc超时时长可设置 */
@property(nonatomic,assign) NSTimeInterval timeoutInterval;

/** 设置是否忽略网络状态 */
@property(nonatomic,assign) BOOL isIgnoreNetStatus;

@end
