//
//  DynamicReleaseInterface+test.m
//  test
//
//  Created by yemingyu on 2017/02/04. All rights reserved.
//

#import "DynamicReleaseInterface+test.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DynamicReleaseInterface (test)

- (NSString*)AESEncryptionKeyName
{
    return @"2403EAF010942_IOS";
}

@end

#pragma clang diagnostic pop

