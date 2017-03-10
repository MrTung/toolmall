//
//  ShopLoginViewController.h
//  toolmall
//
//  Created by mc on 15/10/13.
//
//

#import <UIKit/UIKit.h>
#import "UserSignInResponse.h"
#import "SESSION.h"
#import "LoginService.h"
//#import "MemberRegiste.h"
//#import "ForgetPassword.h"
#import "UIBaseController.h"
#import "FavoriteListController.h"

@interface ShopLoginViewController:UIBaseController<ServiceResponselDelegate,UITextFieldDelegate>
{
    LoginService *loginService;
//    NSString *verifyCode;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_Name;//用户名
@property (strong, nonatomic) IBOutlet UITextField *txt_Pwd;//密码
@property (strong,nonatomic) IBOutlet UITextField *txt_Varify;//验证码文本框
@property (strong, nonatomic) IBOutlet UIView *yView;//验证码背景色
//@property (strong, nonatomic) IBOutlet UILabel *codeLabel;//验证码
@property (weak, nonatomic) IBOutlet UIImageView *codeImg; //验证码

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn; // 眼睛

@property (strong, nonatomic) IBOutlet UIButton *btnExchangeCode;//换验证码按钮
//免费注册按钮
@property (nonatomic, strong) IBOutlet UIButton *btnRegiste;
//找回密码按钮
@property (nonatomic, strong) IBOutlet UIButton *btnForgetPsw;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;


@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic) long cartId;
@property (nonatomic, strong) NSString * nextPageWhenLogined;
@property (nonatomic, assign) BOOL popView;

@end
