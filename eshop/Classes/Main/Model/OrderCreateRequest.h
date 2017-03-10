//
//  OrderCreateRequest.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"
#import "AppInvoice.h"

@interface OrderCreateRequest : BaseModel
@property int paymentMethodId;
@property int shippingMethodId;
@property NSString * couponCode;

@property SESSION* session;

@property AppInvoice* invoice;

@property Boolean isUseBalance;

@property NSString * channel;

@property Address* receiver;

@property NSMutableArray * productIds;

@property NSMutableArray * quantities;
@end
