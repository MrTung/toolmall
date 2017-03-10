//
//  AppSmsAuthCode.h
//  eshop
//
//  Created by mc on 16/1/25.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppSmsAuthCode : BaseModel
@property int id;
@property NSString *authCode;
@property int countDown;
@end
