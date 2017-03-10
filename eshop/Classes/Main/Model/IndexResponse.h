//
//  IndexResponse.h
//  eshop
//
//  Created by mc on 16/3/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppIndexUrl.h"
@interface IndexResponse : BaseModel

@property NSArray *greatBrands;
@property NSArray *productCategories;
@property NSArray *topAdvs;
@property NSArray *shortcutLinks;
@property NSArray *iOSShortcutLinks;
@property NSArray *recommands;
@property NSArray *hotActivities;
@property Status * status;

@property NSDictionary *appparasetting;
@property NSString *hotActivityLogo;

+ (Class)greatBrands_class;

+ (Class)productCategories_class;

+ (Class)topAdvs_class;

+ (Class)shortcutLinks_class;

+ (Class)recommands_class;

+ (Class)hotActivities_class;

+ (Class)iOSShortcutLinks_class;

+ (Class)appparasetting_class;

+ (Class)hotActivityLogo_class;

@end
