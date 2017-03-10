//
//  APRemoteLogger.h
//  APRemoteLogging
//
//  Created by tashigaofei on 14-6-23.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APMonitorPointDataDefines.h"
#import "APLogAddions.h"

static  NSString * const kCurrentControlActionIDDidChanged = @"CurrentControlActionIDDidChanged";

typedef NS_ENUM(NSInteger, APRemoteLoggerPageInfomationType) {
    APRemoteLoggerPageInfomationMiniType
};

@interface APRemoteLogger : NSObject
/**
 *  新的行为埋点接口。8.3之前的老的打点不要修改成调用此接口。8.3以后（含）新开的页面调用此接口。
 客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param actionId  action ID 必填，标识一个埋点的类别，可用actionID定义在APMonitorPointDataDefines.h
                                                文件中
 *  @param extParams 扩展参数，业务自己根据需要填充。数组元素最多4个，第四个元素可以是字典，
                                    字典内容可自定义，字典会被转换成key-value的字符串计入日志
 *  @param appId     子应用ID（业务的bizID） 必填
 *  @param seed      埋点ID（后端定义的，找@君边@望乡生成）
 *  @param ucId      用例编号（后端定义的，找@君边@望乡生成） 必填
 *                   warning：埋点ID和用例编号请自己生成前缀，之后找@温皇来确认，上述两位已经不负责这部分了
 */
+(void)writeLogWithActionId:(NSString *)actionId
                   extParams:(NSArray *)extParams
                       appId:(NSString *)appId
                        seed:(NSString *)seed
                        ucId:(NSString *)ucId;


/**
 *  新的行为埋点接口。8.3之前的老的打点不要修改成调用此接口。8.3以后（含）新开的页面调用此接口。
 客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param actionId  action ID 必填，标识一个埋点的类别，可用actionID定义在APMonitorPointDataDefines.h
 文件中
 *  @param extParams 扩展参数，业务自己根据需要填充。数组元素最多4个，第四个元素可以是字典，
 字典内容可自定义，字典会被转换成key-value的字符串计入日志
 *  @param appId     子应用ID（业务的bizID） 必填
 *  @param seed      埋点ID（后端定义的，找@君边@望乡生成）
 *  @param ucId      用例编号（后端定义的，找@君边@望乡生成） 必填
 *                   warning：埋点ID和用例编号请自己生成前缀，之后找@温皇来确认，上述两位已经不负责这部分了
 *  @param bizType   业务类型
 */

+(void)writeLogWithActionId:(NSString *)actionId
                  extParams:(NSArray *)extParams
                      appId:(NSString *)appId
                       seed:(NSString *)seed
                       ucId:(NSString *)ucId
                    bizType:(NSString *)bizType;



/**
 *  新的行为埋点接口。8.3之前的老的打点不要修改成调用此接口。8.3以后（含）新开的页面调用此接口。
 客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param actionId  action ID 必填，标识一个埋点的类别，可用actionID定义在APMonitorPointDataDefines.h
 文件中
 *  @param extParams 扩展参数，业务自己根据需要填充。数组元素最多4个，第四个元素可以是字典，
 字典内容可自定义，字典会被转换成key-value的字符串计入日志
 *  @param appId     子应用ID（业务的bizID） 必填
 *  @param seed      埋点ID（后端定义@望乡生成）
 *  @param ucId      用例编号（后端定义@望乡生成） 必填
 *                   warning：埋点ID和用例编号请自己生成前缀，之后找@温皇来确认，上述两位已经不负责这部分了
 *  @param bizType   业务类型
 *  @param formatterDictionary  业务可以根据需求自定义formatter字典值，pageid可以通过此字典参数设置
 *  日志级别可以通过字典参数设置
 */

+ (void)writeLogWithActionId:(NSString *)actionId
                  extParams:(NSArray *)extParams
                      appId:(NSString *)appId
                       seed:(NSString *)seed
                       ucId:(NSString *)ucId
                    bizType:(NSString *)bizType
        formatterDictionary:(NSDictionary *)formatterDictionary;


/**
 *   注意：新的埋点不要调用此接口，为保持兼容以前的代码所以保留
 *              8.3之前的老的页面继续使用此接口，8.3新开的页面使用writeLogWithActionId:..这个接口
 *
 *  @param dict log 字典
 */
+(void)writeLogWithLogDictionary:(NSDictionary *) dict /*__deprecated*/;

/**
 *  性能埋点接口，客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param tpye 类型
 *  @param subType 子类型，业务可以自己定义
 *  @param extraParams 扩展字段，共四个item，第四个item是字典，字典内容可自定义，字典会被转换成key-value的字符串计入日志
 */
+ (void)writePerformanceLogWithType:(APLogType)type
                            subType:(NSString *)subType
                        extraParams:(NSArray *)extraParams;




/**
 *  性能埋点接口，客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param tpye 类型
 *  @param subType 子类型，业务可以自己定义
 *  @param extraParams 扩展字段，共四个item，第四个item是字典，字典内容可自定义，字典会被转换成key-value的字符串计入日志
 *  @param formatterDictionary 业务可以根据需求自定义formatter字典值，格式头可以通过此字典参数设置
 *  @param perUploadNum达到number条日志时，触发一次日志上传，当number＝＝1时，实时上传日志。0表示忽略此参数.
 */
+ (void)writePerformanceLogWithType:(APLogType)type
                            subType:(NSString *)subType
                        extraParams:(NSArray *)extraParams
                formatterDictionary:(NSDictionary *)formatterDictionary
                       perUploadNum:(NSUInteger)number;



/**
 *  埋点接口，客户端版本、用户ID、设备ID、操作系统版本、网络类型、设备类型、软件版本会自动填充，不需要业务埋点。
 *
 *  @param tpye 类型,每种类型对应一个日志文件
 *  @param subType 子类型，业务可以自己定义，用于过滤筛选用
＊ @param extraParams 扩展字段，共四个item，第四个item是字典，字典内容可自定义， 字典会被转换成key-value的字符串计入日志
 *  @param perUploadNum 达到num条日志时，触发一次日志上传，当num＝＝1时，实时上传日志。0表示忽略此参数.
 */

+ (void)writeWithType:(APLogType)type subType:(NSString *) subType
           paramArray:(NSArray *) extraParams perUploadNum:(NSUInteger) num;



/**
 *  界面点击的ActionToken(TraceID)
 *
 *  @return 最近界面点击的ActionToken(TraceID)
 */
+(NSString *) currentActionToken;

/**
 *  界面点击的ActionToken的生成时间戳，为精简RPC包大小而提供
 *
 *  @return 最近界面点击的ActionToken的生成时间戳
 */
+(unsigned long long) tokenTimestamp;

/**
 *  界面点击的最近一个控件标识
 *
 *  @return 最近界面点击的最近一个控件标识
 */
+(NSString *) currentActionControlID;

/**
 *  当前页面的ID
 *
 *  @return 当前页面的ID
 */
+(NSString *) currentPageID;

+(NSString *) lastPageID;

+(NSString *) currentSubAppID;

+(void) resetCurrentPageId:(NSString *)pageId;


/**
 *  页面数据准备好到达可用状态，由业务主动调用
 *
 *  @return void
 */
+ (void)pageDidFinishInitializing;



/**
 *  字符串数组格式化转成str1|str2|str3格式字符串
 *
 *  @param array 字符串数组
 *
 *  @return 格式化后字符串
 */
+ (NSString *)convertToStringFromArray:(NSArray *)array;

/**
 *  设置扩展参数，支持扩展参数的日志模型（行为，性能）
 *  字典转成 key=value^key=value^key=value 格式字符串
 *
 *  @return void
 */
+ (void)setFoundationExtended:(NSDictionary *)dict;

/**
 *  字典格式化 转成 key:value&key:value&key:value 格式字符串
 *
 *  @param dictionary 字典
 *  @param kvSeparator 可以为空，默认使用:连接，字典key和value的连接字符（比如key:value）
 *  @param componentsSeparator 可以为空，默认使用&连接，每队key，value组合后的连接字符（比如key:value&key:value）
 *  @return 格式化后的字符串
 *
 */
+ (NSString *)convertToStringFromDictionary:(NSDictionary *)dictionary
                                kvSeparator:(NSString *)separator1
                        componentsSeparator:(NSString *)separator2;



/**
 *  页面打开
 *  @param spmId 代表当前页面的spm
 *  @param index  pageid索引
 *  @return void
 *
 */
+ (void)logPageStartWithSpmId:(NSString *)spmId index:(NSObject *)index;



/**
 *  页面结束，会生成openpage埋点
 *  @param spmId 代表当前页面的spm
 *  @param index  pageid索引
 *  @param param 手动埋点扩展参数4
 *  @return void
 */
+ (void)logPageEndWithSpmId:(NSString *)spmId index:(NSObject *)index bizType:(NSString *)bizType param:(NSDictionary *)param;



/**
 *  取索引的pageid
 *  @param index  pageid索引
 *  @return 页面流水号
 */
+ (NSString *)pageIdForIndex:(NSObject *)index;




/**
 *  取索引的pageid的时间戳
 *  @param index  pageid索引
 *  @return 页面流水号的时间戳
 */
+ (NSString *)pageIdTimestampForIndex:(NSObject *)index;




/**
 *  取索引的spmid
 *  @param index  pageid索引
 *  @return 页面spmid
 */
+ (NSString *)spmIdForIndex:(NSObject *)index;





/**
 *  取索引的信息
 *  @param index  pageid索引
 *  @param type  pageInfo类型
 *  @return 页面信息
 */
+ (NSString *)pageInfomationForIndex:(NSObject *)index forType:(APRemoteLoggerPageInfomationType)type;



/**
 *  清除所有无效的历史流水号
 */
+ (void)resetPageMonitorContext;



/**
 *  向spmpage列表中添加page页
 */
+ (void)addSpmPage:(NSString *)spmPage;



/**
 *  得到日志等级
 */
+ (NSInteger)levelNumberForString:(NSString *)strLevel;




/**
 *  设置外部开关值
 */
+ (void)setSwitchValue:(NSString *)value forKey:(NSString *)key;


#pragma mark -
#pragma mark 以下函数业务不要调用

+(void)writeCrashLog:(NSString *) report vcStack:(NSString *) vcStack;
+(NSDictionary*)stateWhenCrashed:(NSString*)vcStack;
+(void)writeCrashLog:(NSString *) report state:(NSDictionary*)state;

+ (void)writePerformanceLogWithType:(APLogType)type
                            subType:(NSString *) subType
                        extraParams:(NSArray *) extraParams
                    actionControlID:(NSString *) controlID
                         actionToke:(NSString *) actionToken;

+(void) writeDiagnoseLog:(NSString *) logString;
+(void)upload;
+ (void)protectExtentionParams:(NSMutableArray *)params;


+(void) logAutoEventWithBizType:(NSString*)bizType params:(NSArray*)params;
+(void) logPageBeginRenderWithPageName:(NSString *) name;
+(void) logPageStartWithPageId:(NSString *) pageId appId:(NSString *) appId
                   sourceAppId:(NSString *) sourceAppId pageName:(NSString *) pageName;

+ (void)logPageMonitorWithMonitorType:(NSString *)monitorType;
+ (NSString *)logPageMonitorType;
+ (NSString *)logFoundationExtended;

NSString *pageDidAppearName(NSString *pageName);
+ (void)logPageEndRenderWithPageName:(NSString *)name;

+(BOOL) statusForWriteLogSwitch:(NSString*) logType;
+(BOOL) statusForSendLogSwitch:(NSString*) logType;

void logApplicationSendEvent(UIEvent * event);
void logSendAction(SEL action, id target, id sender, UIEvent* event);

+(void) checkCrashLogWithCompletionBlock:(void (^)(void)) block;
void updateSwitchProfile(NSString *actionType);

// 添加OC版本的接口，为了利用OC的动态特性实现模块间解耦合
+ (void)SLWriteMonitorLog:(NSDictionary*)attachDict appID:(NSString*)appID monitorType:(NSString*)monitorType subMonitorType:(NSString*)subMonitorType;
+ (void)APWriteNetLog:(NSString*)identifier size:(NSString*)size type:(NSString*)type owner:(NSString*)owner extDict:(NSDictionary*)extDict;
void  SLWriteMonitorLog(NSDictionary * attachDict, NSString* appID, NSString *monitorType, NSString *subMonitorType);
void APWriteNetLog(NSString *identifier, NSString *size, NSString* type, NSString *owner, NSDictionary * extDict);

/**
 *   暂停日志上传，最大暂停时间为60s，时间过后自动打开日志上传
 *   设置这个机制的原因是防止调用方异常，没有调用resumeLogUploading等情况下，导致日志无法上传。
 *
 *  @param secondes 自定义的日志暂停上传时间，最大值为60s，最小值为1s，其余值将导致默认暂停10s
 */
+(void) suspendLogUploadingForSeconds:(int) seconds;

/**
 *   立即恢复日志上传功能
 */
+(void) resumeLogUploading;


@end
