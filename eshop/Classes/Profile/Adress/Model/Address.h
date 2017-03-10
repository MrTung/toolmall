//
//  Address.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface Address : BaseModel

@property Boolean isDefault;

@property NSString* sign_building;

@property NSString* consignee;

@property NSString* tel;

@property NSString* zipcode;

@property int area;

@property NSString* areaName;

@property int id;

@property NSString* email;

@property NSString* address;

@property NSString* bestTime;

@property NSString* mobile;


@end
