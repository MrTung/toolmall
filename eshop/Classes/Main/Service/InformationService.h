//
//  InformationService.h
//  eshop
//
//  Created by sh on 16/11/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseService.h"

#import "CountMemberRequest.h"

@interface InformationService : BaseService

/**
 * 补充：信息监测_获取是否获取判断信息*/
- (void)getIsCheckEnabled;

/**
 *补充：信息监测_请求参数*/
- (void)getPerformMessageWithtab:(NSString *)tab time:(NSTimeInterval)time param:(NSDictionary*)param;

/**
 *补充：信息监测_返回数据*/
- (void)getPerformMessageWithtab:(NSString *)tab time:(NSDate *)time obj:(NSDictionary*)obj;

/**
 *补充：信息监测_返回错误信息*/
- (void)getPerformMessageWithtab:(NSString *)tab time:(NSDate *)time error:(NSError*)error;

/**
 *补充：信息监测_获取开始时间*/
- (NSTimeInterval)getMarginTimeWithbeginTime:(NSDate *)beginTime;

@end
