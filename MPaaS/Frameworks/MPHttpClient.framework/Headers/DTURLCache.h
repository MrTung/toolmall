//
//  DTURLCache.h
//  APMobileNetwork
//
//  Created by WenBi on 13-5-25.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTURLCache : NSURLCache

+ (DTURLCache *)sharedCache;

+ (NSURLRequest *)etagRequest:(NSData *)requestData;

- (NSString *)ETagForRequest:(NSURLRequest *)request;

@end
