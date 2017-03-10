//
//  MPAnalysisHelper.h
//  MPAnalysis
//
//  Created by yangwei on 16/12/6.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPAnalysisHelper : NSObject

+ (instancetype)sharedInstance;

//启动性能监控,一般在启动后立刻调用，例如didFinishLauncher中
+ (void)startPerformanceMonitor;

// 设置电量消耗的统计时间，默认为1800秒，也就是应用累计使用半个小时，将电量使用情况上报一次。最小设置值为300秒, 设置为0或不设置都是默认1800秒,如果需要设置，在启动性能监控前设置
+ (void)setBatteryMonitorPeriod:(NSTimeInterval)seconds;

/**
 *  使用日志记录App启动的时间，根据业务需要在合适的时机调用此方法写入报活日志，一般启动时机为app启动到闪屏结束首页显示出来的时间。
 *  @param time          启动耗费的时间，单位毫秒(ms)
 */
- (void)writeLogForStartupWithTime:(NSTimeInterval )time;

/**
 *  是否存在闪退日志，如果有则上传日志
 *
 */
- (void)writeLogForCrashReporter;

/**
 *  使用日志记录的数据进行报活，根据业务需要在合适的时机调用此方法写入报活日志，一般每次冷启动算一次报活，可在didFinishLauncher中调用此方法。
 *  另外此方法默认会监听后台回前台的通知，可以配置从后台切回前台的报活最小间隔时间。
 *  从后台切回前台时，距离上次报活时间少于多少秒时，不再报活。默认最小报活间隔为0，即每次回前台都会报活一次
 *  业务可重写 - (NSTimeInterval)logReportActiveMinInterval 进行设置
 */
- (void)writeLogForReportActive;

@end
