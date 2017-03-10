//
//  CheckCaptchaService.h
//  eshop
//
//  Created by sh on 17/1/4.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseService.h"

@interface CheckCaptchaService : BaseService

// 校验图片验证码
- (void)chackImgByCaptchaId:(NSString *)captchaId captcha:(NSString *)captcha;

@end
