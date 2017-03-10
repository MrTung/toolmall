//
//  OrderInfoResponse.h
//  eshop
//
//  Created by mc on 15/11/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppOrderInfo.h"

@interface OrderInfoResponse : BaseModel

@property Status *status;
@property AppOrderInfo *data;
@end
