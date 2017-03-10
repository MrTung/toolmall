//
//  OrderCalculateRequest2.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppPaymentMethod.h"
#import "Address.h"
#import "AppInvoice.h"

@interface OrderCalculateRequest2 : BaseModel
@property NSMutableArray *orders;
@property AppPaymentMethod *paymentMethod;
@property Address *receiver;
@property SESSION *session;
@property AppInvoice *invoice;
@property Boolean isUseBalance;
@end
