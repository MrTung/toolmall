//
//  APLogTrackManager.h
//  APRemoteLogging
//
//  Created by majie on 16/10/27.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APLogTrackAgent.h"

@interface APLogTrackPageInfo : NSObject

@property (atomic, readonly, copy) NSString *pageId;
@property (atomic, readonly, copy) NSString *timestamp;
@property (atomic, readonly, copy) NSString *spmId;
@property (atomic, readonly, copy) NSString *information;
@property (atomic, readonly, assign) BOOL needRpc;

@end


@interface APLogTrackManager : NSObject


+ (void)logPageStartWithIndex:(NSObject *)index context:(APLogTrackContext *)context;


+ (void)logPageEndWithIndex:(NSObject *)index;


+ (void)logPageUpdateWithIndex:(NSObject *)index context:(APLogTrackContext *)context;


+ (void)logPageUpdateWithIndex:(NSObject *)index context:(APLogTrackContext *)context updateType:(APLogTrackUpdateType)updateType;


+ (void)logAutoClickWithContext:(APLogTrackContext *)context;


+ (APLogTrackPageInfo *)pageInfoWithIndex:(NSObject *)index;

@end
