//
//  InformationService.m
//  eshop
//
//  Created by sh on 16/11/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "InformationService.h"

//#import <sys/sysctl.h>
//#import <mach/mach.h>
//#import "MonitorIOS.h"

#include <mach/mach_host.h>
//#include <mach-o/arch.h>
#import "sys/utsname.h"
#import "SESSION.h"
#define getIsCheckEnabledUrl @"https://www.toolmall.com/wap/error/getIsCheckEnabled.jhtm"
#define getPerformMessageUrl @"https://www.toolmall.com/wap/error/getPerformMessage.jhtm"

@implementation InformationService

#pragma mark - /*补充：信息监测_请求参数*/

- (void)getPerformMessageWithtab:(NSString *)tab time:(NSTimeInterval)time param:(NSDictionary*)param {
    
    if (tab.length) {
//        [self getCPUType];
        
        NSRange range = [tab rangeOfString:@".jhtm"];
        NSString *urlStr = [tab substringToIndex:range.location];
        NSArray *tabArray = [urlStr componentsSeparatedByString:@"/"];
        NSString *checkValue = [[NSUserDefaults standardUserDefaults] valueForKey:CheckValue];
        
//      checkValue = @"product.search2"; // 测试
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:IsCheckEnabled] && checkValue.length) {
            
            NSArray *checkArray = [checkValue componentsSeparatedByString:@","];
            
            for (NSString *checkStr in checkArray) {
                
                BOOL isPrefix = [checkStr hasPrefix:tabArray.firstObject];
                
                if (isPrefix) {
                    
                    BOOL isSuffix = [checkStr hasSuffix:@"*"];
                    BOOL isSuffix2 = [checkStr hasSuffix:tabArray.lastObject];
                    
                    if (isSuffix || isSuffix2) {
                        
                        NSString *versionSdk = [NSString stringWithFormat:@"%@ %@(%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
                        
                        NSString *versionName = [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
                        
                        NSString *deviceId = [UIDevice currentDevice].name;
                        NSString *model = [self deviceVersion];
                        NSString *cpu_abi = @"";
                        NSString *board = @"";
                        NSString *cellLocation = @"";
                        NSString *subscriberId = [NSString stringWithFormat:@"%d", [SESSION getSession].uid];
                        NSString *versionCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                        NSNumber *timeNumber = [NSNumber numberWithDouble:time];
                        if (tab.length && timeNumber && param.count && versionSdk.length && versionName.length && deviceId.length && model.length) {
                            
                            NSDictionary *loaddic = [NSDictionary dictionaryWithObjectsAndKeys: versionSdk, @"versionSdk", deviceId, @"deviceId", model, @"model", versionName, @"versionName", tab, @"tab", timeNumber, @"time", param, @"param", cpu_abi, @"CPU_ABI", board, @"BOARD", cellLocation, @"cellLocation", subscriberId, @"subscriberId", versionCode, @"versionCode",nil];
                            
                            
                            NSString *object = [self dictionaryToJson:loaddic];
                            
                            [self upLoagDataPostJson:object];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - /*补充：信息监测_返回数据*/

- (void)getPerformMessageWithtab:(NSString *)tab time:(NSDate *)time obj:(NSDictionary*)obj {
    
    if (tab.length) {
        
        NSRange range = [tab rangeOfString:@".jhtm"];
        NSString *urlStr = [tab substringToIndex:range.location];
        NSArray *tabArray = [urlStr componentsSeparatedByString:@"/"];
        NSString *checkValue = [[NSUserDefaults standardUserDefaults] valueForKey:CheckValue];
        
//        checkValue = @"product.search"; // 测试
#pragma mark = 搜索结果数据过滤
        
        if ([tab rangeOfString:@"product/search"].location != NSNotFound || [tab rangeOfString:@"list"].location != NSNotFound) {
            
            NSArray *dataArr = [obj valueForKey:@"data"];
            obj = [[NSMutableDictionary alloc] init];
            [obj setValue:[NSString stringWithFormat:@"%lu", (unsigned long)dataArr.count] forKey:@"data.count"];
        }
        
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:IsCheckEnabled] && checkValue.length) {
            
            NSArray *checkArray = [checkValue componentsSeparatedByString:@","];
            
            for (NSString *checkStr in checkArray) {
                
                BOOL isPrefix = [checkStr hasPrefix:tabArray.firstObject];
                
                if (isPrefix) {
                    
                    BOOL isSuffix = [checkStr hasSuffix:@"*"];
                    BOOL isSuffix2 = [checkStr hasSuffix:tabArray.lastObject];
                    
                    if (isSuffix || isSuffix2) {
                        
                        NSString *versionSdk = [NSString stringWithFormat:@"%@ %@(%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
                        
                        NSString *versionName = [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
                        
                        NSString *deviceId = [UIDevice currentDevice].name;
                        NSString *model = [self deviceVersion];
                        NSString *cpu_abi = @"";
                        NSString *board = @"";
                        NSString *cellLocation = @"";
                        NSString *subscriberId = [NSString stringWithFormat:@"%d", [SESSION getSession].uid];
                        NSString *versionCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                        NSNumber *dateNumber = [NSNumber numberWithDouble:[time timeIntervalSince1970]];
                        if (tab.length && time && obj.count && versionSdk.length && versionName.length && deviceId.length && model.length) {
                            
                            NSDictionary *loaddic = [NSDictionary dictionaryWithObjectsAndKeys: versionSdk, @"versionSdk", deviceId, @"deviceId", model, @"model", versionName, @"versionName", tab, @"tab", dateNumber, @"time", obj, @"param", cpu_abi, @"CPU_ABI", board, @"BOARD", cellLocation, @"cellLocation", subscriberId, @"subscriberId", versionCode, @"versionCode",nil];
                            
                            
                            NSString *object = [self dictionaryToJson:loaddic];
                            
                            if (object.length>2000) {
                                
                                object = [object substringToIndex:1000];
                            }
                            
                            [self upLoagDataPostJson:object];
                        }
                    }
                }
            }
        }
    }
}


#pragma mark - /*补充：信息监测_返回错误信息*/

- (void)getPerformMessageWithtab:(NSString *)tab time:(NSDate *)time error:(NSError*)error {
    
    if (tab.length) {
        
        NSRange range = [tab rangeOfString:@".jhtm"];
        NSString *urlStr = [tab substringToIndex:range.location];
        NSArray *tabArray = [urlStr componentsSeparatedByString:@"/"];
        NSString *checkValue = [[NSUserDefaults standardUserDefaults] valueForKey:CheckValue];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:IsCheckEnabled] && checkValue.length) {
            
            NSArray *checkArray = [checkValue componentsSeparatedByString:@","];
            
            for (NSString *checkStr in checkArray) {
                
                BOOL isPrefix = [checkStr hasPrefix:tabArray.firstObject];
                
                if (isPrefix) {
                    
                    BOOL isSuffix = [checkStr hasSuffix:@"*"];
                    BOOL isSuffix2 = [checkStr hasSuffix:tabArray.lastObject];
                    
                    if (isSuffix || isSuffix2) {
                        
                        NSString *versionSdk = [NSString stringWithFormat:@"%@ %@(%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
                        
                        NSString *versionName = [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
                        
                        NSString *deviceId = [UIDevice currentDevice].name;
                        NSString *model = [self deviceVersion];
                        NSString *cpu_abi = @"";
                        NSString *board = @"";
                        NSString *cellLocation = @"";
                        NSString *subscriberId = [NSString stringWithFormat:@"%d", [SESSION getSession].uid];
                        NSString *versionCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                        NSNumber *dateNumber = [NSNumber numberWithDouble:[time timeIntervalSince1970]];
                        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
                        [CommonUtils fillIntToDictionary:params key:@"_code" value:error.code];
                        [CommonUtils fillStrToDictionary:params key:@"_domain" value:error.domain];
                        [CommonUtils fillStrToDictionary:params key:@"_localizedDescription" value:error.localizedDescription];
//                        [CommonUtils fillStrToDictionary:params key:@"_errorFailingURLKey" value:error.userInfo[@"NSErrorFailingURLKey"]];
                        
                        if (tab.length && time && params.count && versionSdk.length && versionName.length && deviceId.length && model.length) {
                            
                            NSDictionary *loaddic = [NSDictionary dictionaryWithObjectsAndKeys: versionSdk, @"versionSdk", deviceId, @"deviceId", model, @"model", versionName, @"versionName", tab, @"tab", dateNumber, @"time", params, @"param", cpu_abi, @"CPU_ABI", board, @"BOARD", cellLocation, @"cellLocation", subscriberId, @"subscriberId", versionCode, @"versionCode",nil];
                            
                            
                            NSString *object = [self dictionaryToJson:loaddic];
                            
                            [self upLoagDataPostJson:object];
                        }
                    }
                }
            }
        }
    }
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)upLoagDataPostJson:(id)param {
    
    NSURL *url = [NSURL URLWithString:getPerformMessageUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *bodyString = [NSString stringWithFormat:@"jsonObject=%@", param];
    
    NSData *data2 = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data2;
    
//    NSURLResponse *response = nil;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                NSLog(@"%@", data);
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                NSLog(@"%@", dataDic);
            });
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark -  /* 补充：信息监测_获取是否获取判断信息*/

- (void)getIsCheckEnabled {
    
    NSURL *url = [NSURL URLWithString:getIsCheckEnabledUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSLog(@"%@", data);
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                NSLog(@"%@", dataDic);
                
                [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"IsCheckEnabled"] forKey:IsCheckEnabled];
                [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"checkValue"] forKey:CheckValue];
            });
        }
    }];
    
    [dataTask resume];
    
    //    NSURLResponse *response = nil;
    //
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //    if (data) {
    //
    //        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
    //        NSLog(@"%@", dataDic);
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"IsCheckEnabled"] forKey:IsCheckEnabled];
    //        [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"checkValue"] forKey:CheckValue];
    //    }
    
}

- (NSTimeInterval)getMarginTimeWithbeginTime:(NSDate *)beginTime {
    
    NSDate *endTime = [NSDate date];
    NSTimeInterval time = [endTime timeIntervalSinceDate:beginTime];
    
    return time;
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
//    NSLog(@"%@", deviceString);
    return deviceString;
}
- (void)getCPUType{
    
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
//    infoCount = HOST_BASIC_INFO_COUNT;
    kern_return_t ret = host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);

    if (ret == KERN_SUCCESS) {
        
//        NSLog(@"cpu_type: %d\n", hostInfo.cpu_type);
//        NSLog(@"cpu_subtype: %d\n", hostInfo.cpu_subtype);
//        NSLog(@"cpu_threadtype: %d\n", hostInfo.cpu_threadtype);
    }
}

/*
- (void)GetCpuUsage {
    
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    NSLog(@"CPU Usage: %f \n", tot_cpu);
    
    MonitorIOS *iOS  = [[MonitorIOS alloc] init];
    [iOS systemStats];
}

- (cpu_type_t)getCpuType {
    
    const NXArchInfo *archInfo = NXGetLocalArchInfo();
    NSLog(@"cputype -> %d", archInfo->cputype);
    NSLog(@"cpusubtype -> %d", archInfo->cpusubtype);
    return archInfo->cputype;
}
*/

/*
- (void)getIsCheckEnabledWithtab:(NSString *)tab time:(NSDate *)time error:(NSError*)error {
    
    NSURL *url = [NSURL URLWithString:getIsCheckEnabledUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            //            NSLog(@"%@", data);
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            NSLog(@"%@", dataDic);
            
            
            NSRange range = [tab rangeOfString:@".jhtm"];
            NSString *urlStr = [tab substringToIndex:range.location];
            NSArray *tabArray = [urlStr componentsSeparatedByString:@"/"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *checkValue = dataDic[@"checkValue"];
                
                if (dataDic[@"IsCheckEnabled"] && checkValue.length) {
                    
                    NSArray *checkArray = [checkValue componentsSeparatedByString:@","];
                    
                    for (NSString *checkStr in checkArray) {
                        
                        BOOL isPrefix = [checkStr hasPrefix:tabArray.firstObject];
                        
                        if (isPrefix) {
                            
                            BOOL isSuffix = [checkStr hasSuffix:@"*"];
                            BOOL isSuffix2 = [checkStr hasSuffix:tabArray.lastObject];
                            
                            if (isSuffix || isSuffix2) {
                                
                                [self getPerformMessageWithtab:tab time:time error:error];
                            }
                        }
                    }
                }
            });
        }
        
    }];
    
    [dataTask resume];
}
*/

@end
