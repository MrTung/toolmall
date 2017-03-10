//
//  SharedAppUtil.m
//  eshop
//
//  Created by 董徐维 on 2017/3/7.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "SharedAppUtil.h"

@implementation SharedAppUtil

+(SharedAppUtil *)defaultCommonUtil
{
    static SharedAppUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[SharedAppUtil alloc]init];
    });
    return util;
}
@end
