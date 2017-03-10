//
//  AddressListResponse.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"
@interface AddressListResponse : BaseModel

@property Status *status;
@property NSMutableArray *data;

+ (Class)data_class;
@end
