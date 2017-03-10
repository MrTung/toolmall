//
//  PaymentPluginListResponse.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppPaymentPlugin.h"
@interface PaymentPluginListResponse : BaseModel

@property Status *status;
@property NSMutableArray *data;

+ (Class)data_class;
@end
