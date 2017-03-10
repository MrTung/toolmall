//
//  AddressAddRequest.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"
@interface AddressAddRequest : BaseModel

@property Address *address;
@property SESSION *session;
@end
