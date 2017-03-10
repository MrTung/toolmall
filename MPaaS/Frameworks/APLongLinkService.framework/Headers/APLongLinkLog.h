//
//  APLongLinkLog.h
//  APLongLinkService
//
//  Created by cuinacai on 14/11/6.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SYNC_LINK = 0,
    SYNC_PROTO,
    SYNC_Diagnose //诊断日志
} LonkLinkLogType;

//subType
extern NSString * const APSyncConnSpdy;
extern NSString * const APSyncConnSSL;
extern NSString * const APSyncConnTCP;
extern NSString * const APSyncConnMMTP;
extern NSString * const APSyncLLInitMMTP;
extern NSString * const APSyncLLInit;
extern NSString * const APSyncLLBU;
extern NSString * const APSyncLLUBU;
extern NSString * const APSyncLLH;
extern NSString * const APSyncExpSpdy;
extern NSString * const APSyncExpMMTP;
extern NSString * const APSyncExpLL;
extern NSString * const APSyncSync1001;
extern NSString * const APSyncSync1003;
extern NSString * const APSyncSync1004;
extern NSString * const APSyncSync2001;
extern NSString * const APSyncSync2002;
extern NSString * const APSyncSync2003;
extern NSString * const APSyncSyncExp;
extern NSString * const APSyncSyncDispatch;
extern NSString * const APSyncSyncCallback;
extern NSString * const APSyncAppstat;
extern NSString * const APSyncNetstat;
extern NSString * const APSyncBgtime;

//扩展参数
extern NSString * const APSyncExtraPara1;
extern NSString * const APSyncExtraPara2;
extern NSString * const APSyncExtraPara3;

@protocol APLongLinkLogInterface <NSObject>
/**
 *  写日志
 *
 *  @param type     日志类型(文件名字)
 *  @param subType  子类型
 *  @param params   参数
 *  @param formater 格式
 */
-(void)logWithType:(LonkLinkLogType)type subType:(NSString *)subType extraParams:(NSDictionary*)params paramsFormater:(NSArray*)formater;

@end

@interface APLongLinkLog : NSObject
/**
 *  设置写日志的实现者
 *
 *  @param logger 实现APLongLinkLogInterface的对象
 */
+(void)setLogger:(id<APLongLinkLogInterface>)logger;
/**
 *  写日志
 *
 *  @param type     日志类型(文件名字)
 *  @param subType  子类型
 *  @param params   参数
 *  @param formater 格式
 */
+(void)logWithType:(LonkLinkLogType)type subType:(NSString *)subType extraParams:(NSDictionary*)params paramsFormater:(NSArray*)formater;
@end


