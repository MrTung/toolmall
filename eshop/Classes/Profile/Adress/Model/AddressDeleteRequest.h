//
//  AddressDeleteRequest.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AddressDeleteRequest : BaseModel

@property NSString *address_id;
@property SESSION *session;
@end
