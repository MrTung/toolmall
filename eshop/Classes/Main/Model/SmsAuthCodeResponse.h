//
//  SmsAuthCodeResponse.h
//  eshop
//
//  Created by mc on 16/1/25.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppSmsAuthCode.h"

@interface SmsAuthCodeResponse : BaseModel
@property(nonatomic,strong) Status *status;
@property(nonatomic,strong) AppSmsAuthCode *data;
@end
