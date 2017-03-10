//
//  OrderCreateResponse2.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppOrderInfo.h"

@interface OrderCreateResponse2 : BaseModel
@property NSMutableArray *data;
@property Status *status;

+ (Class)data_class;
@end
