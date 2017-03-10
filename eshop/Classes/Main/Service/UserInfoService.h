//
//  UserInfoService.h
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "BaseService.h"
#import "UserInfoResponse.h"
#import "UserSignInResponse.h"
#import "StatusResponse.h"
#import "SmsAuthCodeResponse.h"
#import "SESSION.h"
#import "AppMemberMoreUpdateRequest.h"
#import "UserSignInResponse.h"
@interface UserInfoService : BaseService

- (void) getUserInfo;

//以前版本的注册
- (void)userRegiste:(NSString*)name password:(NSString*)password email:(NSString*)email mobileNo:(NSString*)mobileNo;

//向服务器请求短信验证码
- (void)getSmsAuthCode:(NSString *)mobileNo chkMobileExist:(NSString *)chkMobileExist;

//注册
- (void)userRegisteMobileNo:(NSString *)mobileNo smsAuthCode:(NSString *)smsAuthCode password:(NSString *)password;

//手机号绑定
- (void)userBondMobileNo:(NSString *)mobileNo authCode:(NSString *)authCode password:(NSString *)password  session:(SESSION *)session;

//修改会员用户名
- (void)userChangeUserName:(NSString *)userName;

//修改会员用户字段
- (void)userChangeUserFieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue;

//上传头像
- (void)uploadHeadImage:(UIImage *)image;

//修改手机号
- (void)userChangeMobileNo:(NSString *)newMobileNo oldMobileNo:(NSString *)oldMobileNo;

//重置密码
- (void)userChangePassword:(NSString *)newPassword;

//验证短信验证码
- (void)userVerifySmsAuthCode:(NSString *)smsAuthCode mobileNo:(NSString *)mobileNo;

//完善信息
- (void)updateMore:(AppMemberMoreUpdateRequest *)request;
@end
