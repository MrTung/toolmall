//
//  AddressUpdateRequest.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"
@interface AddressUpdateRequest : BaseModel

@property Address *address;
@property NSString *address_id;
@property SESSION *session;
@end
