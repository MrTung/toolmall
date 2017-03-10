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
#import "UIBaseController.h"
#import "USER.h"
#import "LXFTextField.h"
#import "CheckCaptchaService.h"
#import "VerifySecurityViewController.h"
@interface GetVerifyCodeViewController:UIBaseController<ServiceResponselDelegate,UITextFieldDelegate>
{
    CheckCaptchaService * checkCaptchaService;
    NSString *verifyCode;
}

@property (strong, nonatomic) IBOutlet LXFTextField *txt_Name;//用户名
@property (strong,nonatomic) IBOutlet LXFTextField *txt_Varify;//验证码文本框
@property (strong, nonatomic) IBOutlet UIView *yView;//验证码背景色
@property (weak, nonatomic) IBOutlet UIImageView *codeImg; //验证码
@property (strong, nonatomic) IBOutlet UIButton *btnExchangeCode;//换验证码按钮
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property USER * user;
//
//@property (nonatomic, strong) NSString * openId;
//@property (nonatomic, strong) NSString * nickName;
//@property (nonatomic) long cartId;

@end
