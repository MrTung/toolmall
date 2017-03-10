//
//  CountMemberRequest.h
//  eshop
//
//  Created by mc on 16/3/14.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface CountMemberRequest : BaseModel

@property Status * status;

@property NSString *imei;

@property NSString *ip;

@property NSString *source;

@property NSString *sourceItem;

@property NSString *wifiId;

@property NSString *phone;

@property NSString *providersName;

@property SESSION *session;

@end
