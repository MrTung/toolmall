//
//  CartItemsRequest.h
//  eshop
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface CartItemsRequest : BaseModel

@property SESSION * session;
@property NSArray * productIds;
@property NSArray * quantities;

@end
