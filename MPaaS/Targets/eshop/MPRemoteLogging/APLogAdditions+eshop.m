//
//  APLogAdditions+eshop.m
//  eshop
//
//  Created by gs on 2017/03/02. All rights reserved.
//

#import "APLogAdditions+eshop.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation APLogAdditions (eshop)

- (NSString*)logServerURL
{
    return @"http://116.62.88.108/loggw/logUpload.do";
}

- (NSArray*)defaultUploadLogTypes
{
    return @[@(APLogTypeBehavior), @(APLogTypeCrash), @(APLogTypeAuto), @(APLogTypeMonitor), @(APLogTypeKeyBizTrace), @(APLogTypePerformance)];
}

- (NSString *)platformID
{
    return @"2403EAF010942_IOS-default";
}

@end

#pragma clang diagnostic pop

