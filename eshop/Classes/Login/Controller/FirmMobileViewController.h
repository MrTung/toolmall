//
//  FirmMobileViewController.h
//  eshop
//
//  Created by mc on 16/1/27.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfoService.h"
#import "SmsAuthCodeResponse.h"
#import "UserInfoResponse.h"

@interface FirmMobileViewController : UIViewController<UITextFieldDelegate,ServiceResponselDelegate>

{
    UserInfoService * userInfoService;
}
@property (nonatomic, strong) UITextField * txtPhoneNumber; //手机号
@property (nonatomic, strong) UITextField * txtMessageCode; //短信验证码
@property (nonatomic, strong) UITextField * txtPassword; //密码

@property (nonatomic, strong) UIButton * btnMessageCode; //短信验证码按钮
@property (nonatomic, strong) UIButton * btnFirmNow; //立即绑定按钮

@property (nonatomic, strong) UILabel * lblProtocol; //用户注册协议
@property (nonatomic, strong) UILabel * lblDescription; //绑定手机描述

@end
