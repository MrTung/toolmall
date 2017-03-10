//
//  AppGoods.m
//  eshop
//
//  Created by mc on 16/3/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "AppGoods.h"

@implementation AppGoods
+ (Class)appProducts_class{
    return [AppProduct class];
}
+ (Class)appSpecifications_class{
    return [AppSpecification class];
}
@end
