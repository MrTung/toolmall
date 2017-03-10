//
//  SharedAppUtil.h
//  eshop
//
//  Created by 董徐维 on 2017/3/7.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedAppUtil : NSObject

@property (nonatomic, retain) UserCacheModel *userCache;

+(SharedAppUtil *)defaultCommonUtil;

@end
