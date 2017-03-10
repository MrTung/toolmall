//
//  DTRpcInterface+eshop.m
//  eshop
//
//  Created by gs on 2017/03/02. All rights reserved.
//

#import "DTRpcInterface+eshop.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DTRpcInterface (eshop)

- (NSString*)gatewayURL
{
    return @"http://116.62.87.66/mgw.htm";
}

- (NSString*)signKeyForRequest:(NSURLRequest*)request
{
    return @"2403EAF010942_IOS";
}

- (NSString *)productId
{
    return @"2403EAF010942";
}

- (NSString*)commonInterceptorClassName
{
    return @"DTRpcCommonInterceptor";
}

@end

#pragma clang diagnostic pop

