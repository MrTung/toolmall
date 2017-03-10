//
//  MsgListResponse.h
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppMessage.h"

@interface MsgListResponse : BaseModel

@property Status *status;
@property NSMutableArray *data;

+ (Class)data_class;
@end
