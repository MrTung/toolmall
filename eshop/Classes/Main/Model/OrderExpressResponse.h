//
//  OrderExpressResponse.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppExpressInfo.h"

@interface OrderExpressResponse : BaseModel
@property Status *status;
@property AppExpressInfo *data;
@end
