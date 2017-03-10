//
//  URLUtils.m
//  eshop
//
//  Created by mc on 16/3/31.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+ (NSURL*)createURL:(NSString*)url{
    return [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
@end
