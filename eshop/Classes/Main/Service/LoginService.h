//
//  LoginService.h
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "BaseService.h"
#import "UserSignInResponse.h"
#import "UIDevice+Extensions.h"

@interface LoginService : BaseService

//正常用户名和密码登录
- (void) loginWithName:(NSString *)name password:(NSString *)password captchaId:(NSString *)captchaId captcha:(NSString *)captcha;


- (void)loginWithQQ:(NSString *)openId nickName:(NSString *)nickName cartId:(long)cartId;


- (void)loginWithWX:(NSString *)openId nickName:(NSString *)nickName cartId:(long)cartId accessToken:(NSString *)accessToken;

@end
