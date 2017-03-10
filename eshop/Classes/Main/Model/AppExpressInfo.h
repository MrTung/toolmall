//
//  AppExpressInfo.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

#import "AppExpressDtl.h"
@interface AppExpressInfo : BaseModel
@property NSMutableArray *content;

+ (Class)content_class;
@end
