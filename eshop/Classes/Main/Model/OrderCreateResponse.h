//
//  OrderCreateResponse.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppOrderInfo.h"

@interface OrderCreateResponse : BaseModel

@property (nonatomic) Status *status;
@property (nonatomic) AppOrderInfo *data;
@end
