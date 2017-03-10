//
//  AppGoods.h
//  eshop
//
//  Created by mc on 16/3/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSpecification.h"
@interface AppGoods : BaseModel
@property NSArray *appProducts ;
@property NSArray *appSpecifications;
@property NSNumber *minPrice;
@property NSNumber *maxPrice;

+ (Class)appProducts_class;
+ (Class)appSpecifications_class;
@end
