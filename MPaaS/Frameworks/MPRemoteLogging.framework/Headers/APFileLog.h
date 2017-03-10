//
//  APFileLog.h
//  APMobileFoundation
//
//  Created by zhengyi on 15/1/19.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

// 日志不加密
#define DebugPackage YES
/**
 *  本地文件log
 */
@interface APFileLog : NSObject

+(instancetype) sharedInstance;

/**
 * @brief 将log写入file.
 *
 * @param  需要写入的log.
 *
 * @return 成功失败.
 */
-(BOOL) writeFileLog:(NSString *)logString;

/**
 * @brief 删除过期的log.
 *
 * @param
 *
 * @return
 */
-(void) deleteExpiredLog;

/**
 * @brief .
 *
 * @param 时间，nil为当天
 *
 * @param completion 执行回调
 */
-(void)getLogByDay:(NSDate*)date resultBlock:(void (^)(NSString *log))completion;

/**
 * @brief log路径下的子目录.
 *
 * @param
 *
 * @return 子目录名字的数组
 */
-(NSArray *)subDirofLogPath;

/**
 * @brief 上传路径下log.
 *
 * @param 上传文件的名字
 *
 * @return
 */

-(void)uploadFileLog:(NSString *)fileName;

/**
 * @brief 上传路径下log.
 *
 * @param 指定时间段，上传文件的名字
 *
 * @return
 */

-(void)uploadFileLogWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime serverFile:(NSString *)fileName;

-(NSArray *)getFilePathArrryInDoc:(NSString *)Document;

-(void)getLogByPath:(NSString *)path resultBlock:(void(^)(NSString *log))completion;
@end
