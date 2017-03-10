//
//  RegisteViewController.m
//  eshop
//
//  Created by mc on 16/1/6.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "RegisteViewController.h"

#import "AppDelegate.h"

@interface RegisteViewController ()
{
    UserInfoService *userInfoService;
    UserSignInResponse *respobj;
    LoginService *loginService;
}

@property (nonatomic, weak) IBOutlet UITextField * phoneTextField; //手机号
@property (nonatomic, weak) IBOutlet UITextField * messageTextField; //短信验证码
@property (nonatomic, weak) IBOutlet UITextField * passwordTextField; //密码
@property (nonatomic, weak) IBOutlet UIButton * btnMessage; //短信验证码按钮
@property (nonatomic, weak) IBOutlet UIButton * eyeBtn; // 眼睛
@property (nonatomic, weak) IBOutlet UIButton * userProtocolButton; //用户注册协议
@property (nonatomic, weak) IBOutlet UIButton * btnRegiste; //确认注册按钮
@property (nonatomic, weak) IBOutlet UIButton * loginBtn; // 直接登录
@property (nonatomic, weak) IBOutlet UIButton * btnQQLogin; //qq登录按钮
@property (nonatomic, weak) IBOutlet UIButton * btnWXLogin; //微信登录按钮

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightLayout90;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH1;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH2;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH3;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH4;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH5;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH6;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH7;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *marginLayoutH8;


@property (nonatomic, assign) int secondsCountDown; //倒计时时间

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation RegisteViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        userInfoService = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
        
        loginService = [[LoginService alloc]initWithDelegate:self parentView:self.view];
        
        self.hidesBottomBarWhenPushed=YES;
        
        return self;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addNavBackButton];
    
    [self initView];
    
    [self createUI];
    
    [self refreshUI];
}

-(void)initView{

    NSString *registeVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_navItem_title"];
    [super addNavTitle:registeVC_navItem_title];
    [super addThreedotButton];
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    
    self.btnRegiste.backgroundColor = redColorSelf;
    [self.loginBtn setTitleColor:redColorSelf forState:(UIControlStateNormal)];
    
    _phoneTextField.delegate = self;
    _messageTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    //    限制手机号码和验证码的长度
    [_phoneTextField addTarget:self action:@selector(limitedNumber:) forControlEvents:UIControlEventEditingChanged];
    [_messageTextField addTarget:self action:@selector(limitedNumber:) forControlEvents:UIControlEventEditingChanged];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showUrl"];

}

#pragma mark 收起键盘 edit by dxw 2017-03-07

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}


- (void)refreshUI {
    
    CGFloat height = TMScreenH-113;
    self.heightLayout90.constant = height*45.0/554;
    self.marginLayoutH1.constant = height*10.0/445;
    self.marginLayoutH2.constant = height*10.0/445;
    self.marginLayoutH3.constant = height*30.0/445;
    self.marginLayoutH4.constant = height*15.0/445;
    self.marginLayoutH5.constant = height*35.0/445;
    self.marginLayoutH6.constant = height*35.0/445;
    self.marginLayoutH7.constant = height*20.0/445;
    self.marginLayoutH8.constant = height*5.0/445;
    
    [self.view setNeedsUpdateConstraints];
    
    // 获取验证码
    NSString *registeVC_btnMessage2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_btnMessage2_title"];
    // 用户名/邮箱/已验证手机
    NSString *registeVC_phoneTextField_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_phoneTextField_plaTitle"];
    // 请输入验证码
    NSString *registeVC_messageTextField_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_messageTextField_plaTitle"];
    // 密码
    NSString *registeVC_passwordTextField_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_passwordTextField_plaTitle"];
    // 《土猫网注册协议》
    NSString *registeVC_userProtocolButton_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_userProtocolButton_title"];
    
    // 注册即视为同意
    NSString *registeVC_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_label1_title"];
    // 无需注册，直接登陆
    NSString *registeVC_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_label2_title"];
    // QQ登录
    NSString *registeVC_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_label3_title"];
    // 微信登录
    NSString *registeVC_label4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_label4_title"];
    // 确认注册
    NSString *registeVC_btnRegiste_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_btnRegiste_title"];
    // 已有账号，直接登录
    NSString *registeVC_loginBtn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_loginBtn_title"];
    
    self.label1.text = registeVC_label1_title;
    self.label2.text = registeVC_label2_title;
    self.label3.text = registeVC_label3_title;
    self.label4.text = registeVC_label4_title;
    [self.btnRegiste setTitle:registeVC_btnRegiste_title forState:(UIControlStateNormal)];
    [self.loginBtn setTitle:registeVC_loginBtn_title forState:(UIControlStateNormal)];
    [self.userProtocolButton setTitle:registeVC_userProtocolButton_title forState:(UIControlStateNormal)];
    [self.btnMessage setTitle:registeVC_btnMessage2_title forState:(UIControlStateNormal)];
    self.phoneTextField.placeholder = registeVC_phoneTextField_plaTitle;
    self.messageTextField.placeholder = registeVC_messageTextField_plaTitle;
    self.passwordTextField.placeholder = registeVC_passwordTextField_plaTitle;
}

#pragma UITextFieldDelegate  限制文本框的长度
- (void)limitedNumber :(UITextField *)textField{
    int number = (textField == _phoneTextField) ? 11:6;
    if (textField.text.length > number) {
        textField.text = [textField.text substringToIndex:number];
    }
}

#pragma 获取短信验证码
- (void)sendMessageAction:(id)sender{
    //向服务器端发送一个请求，获取一个短信验证码
    NSString * vMobilePhone = [CommonUtils trim:_phoneTextField.text];
    if (vMobilePhone.length == 0){
        // @"请输入手机号"
        NSString *registeVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_toastNotification_msg1"];
        [CommonUtils ToastNotification:registeVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    [userInfoService getSmsAuthCode:self.phoneTextField.text chkMobileExist:@"Y"];
}

//确认注册
- (void)registeAction:(id)sender{
    
    if (![self saveValidate]){
        return;
    }
    [self save];
}

-(void)startTime{
    
    __block int timeout = _secondsCountDown; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // @"重新发送"
                NSString *registeVC_btnMessage_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_btnMessage_title"];
                //设置界面的按钮显示 根据自己需求设置
                [_btnMessage setTitle:registeVC_btnMessage_title forState:UIControlStateNormal];
                _btnMessage.userInteractionEnabled = YES;
            });
        }else{
//            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.3d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_btnMessage setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _btnMessage.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    
    if ([url isEqual: api_getSmsAuthCode]){
        SmsAuthCodeResponse *smsAuthCodeResponse = (SmsAuthCodeResponse *)response;
        Status *status = smsAuthCodeResponse.status;
        if (status.succeed == 1){

            _secondsCountDown = 120;
            [self startTime];
        }
    }
    else if ([url isEqual: api_mobileregister]){
        
        respobj = (UserSignInResponse *)response;
        
        if (respobj.status.succeed == 1) {
            
            [[Config Instance] saveUserInfo:@"uid" withvalue:[[NSString alloc] initWithFormat:@"%d", respobj.data.user.id]];
            [[Config Instance] saveUserInfo:@"sid" withvalue:respobj.data.session.sid];
            [[Config Instance] saveUserInfo:@"uname" withvalue:respobj.data.user.name];
            [[Config Instance] saveUserInfo:@"key" withvalue:respobj.data.session.key];
            [[Config Instance] saveUserInfo:@"email" withvalue:respobj.data.user.email];
            [[Config Instance] saveUserInfo:@"memberrank" withvalue:respobj.data.user.rank_name];
            [[Config Instance] saveCartId:respobj.data.session.cartId];
            [[Config Instance] saveCartToken:respobj.data.session.cartToken];
            
            [SESSION setSession:nil];
            
            //保存用户信息
            [ArchiverCacheHelper saveObjectToLoacl:[[UserCacheModel alloc] initWithBaseModel:respobj] key:User_Archiver_Key filePath:User_Archiver_Path];
            
            //设置全局缓存信息
            [SharedAppUtil defaultCommonUtil].userCache = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];

            
            if (respobj.data.showUrl) {
            
                MyWebView *myWebView = [[MyWebView alloc] init];
                myWebView.type = @"register";
                myWebView.navTitle = @" ";
                myWebView.loadUrl = respobj.data.donateUrl;
                [self.navigationController pushViewController:myWebView animated:YES];
                
            } else {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else {
            [CommonUtils ToastNotification:respobj.status.error_desc andView:self.view andLoading:NO andIsBottom:YES];
        }

    }
    
    else if([url isEqual:api_qqlogin] || [url isEqual:api_wxlogin]){
        
        respobj = (UserSignInResponse *)response;

        if (respobj.status.succeed == 1) {
            [[Config Instance] saveUserInfo:@"uid" withvalue:[[NSString alloc] initWithFormat:@"%d", respobj.data.user.id]];
            [[Config Instance] saveUserInfo:@"sid" withvalue:respobj.data.session.sid];
            [[Config Instance] saveUserInfo:@"uname" withvalue:respobj.data.user.name];
            [[Config Instance] saveUserInfo:@"key" withvalue:respobj.data.session.key];
            [[Config Instance] saveUserInfo:@"email" withvalue:respobj.data.user.email];
            [[Config Instance] saveUserInfo:@"memberrank" withvalue:respobj.data.user.rank_name];
            [[Config Instance] saveCartId:respobj.data.session.cartId];
            [[Config Instance] saveCartToken:respobj.data.session.cartToken];
            
            //保存用户信息
            [ArchiverCacheHelper saveObjectToLoacl:[[UserCacheModel alloc] initWithBaseModel:respobj] key:User_Archiver_Key filePath:User_Archiver_Path];
            
            //设置全局缓存信息
            [SharedAppUtil defaultCommonUtil].userCache = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];


            [SESSION setSession:nil];
            if (!respobj.data.user.mobile) {
                FirmMobileViewController * firm = [[FirmMobileViewController alloc]initWithNibName:@"FirmMobileViewController" bundle:nil];
                [self.navigationController pushViewController:firm animated:YES];
            }
            else
                [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


- (void)save{
    NSString *mobileNo = [CommonUtils trim:_phoneTextField.text];
    NSString *messageNo = [CommonUtils trim:_messageTextField.text];
    NSString *password = [CommonUtils trim:_passwordTextField.text];
//    向服务器端发送注册请求，包含三个参数，手机号，短信验证码，密码
    [userInfoService userRegisteMobileNo:mobileNo smsAuthCode:messageNo password:password];
}

- (Boolean)saveValidate{

    NSString * vMobilePhone = [CommonUtils trim:_phoneTextField.text];
    NSString * vMessageNo = [CommonUtils trim:_messageTextField.text];
    NSString * vPassword = [CommonUtils trim:_passwordTextField.text];
    
    // @"请输入手机号"
    NSString *registeVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_toastNotification_msg2"];
    // @"请输入短信验证码"
    NSString *registeVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_toastNotification_msg3"];
    // @"请输入密码"
    NSString *registeVC_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_toastNotification_msg4"];
    if (vMobilePhone.length == 0){
        [CommonUtils ToastNotification:registeVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }

    if (vMessageNo.length == 0){
        [CommonUtils ToastNotification:registeVC_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }
    if (vPassword.length == 0){
        [CommonUtils ToastNotification:registeVC_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }

    return true;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    if (textField == _passwordTextField){
        //新增保存
        if (![self saveValidate]){
            return NO;
        }
        [self save];
    }
    return YES;
}


#pragma 第三方登录
//qq登录
- (void)qqLoginAction{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            [loginService loginWithWX:resp.openid nickName:resp.name cartId:[SESSION getSession].cartId accessToken:resp.accessToken];
        }
    }];
}

//微信登录
- (void)wxLoginAction{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            [loginService loginWithWX:resp.openid nickName:resp.name cartId:[SESSION getSession].cartId accessToken:resp.accessToken];
            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

//布局页面
- (void)createUI{
    
//    _phoneTextField.keyboardType = UIKeyboardTypeDefault;
//    
//    _messageTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    
    _passwordTextField.secureTextEntry = YES;
    
    [_eyeBtn addTarget:self action:@selector(showPasswordOrNot:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMessage addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_userProtocolButton addTarget:self action:@selector(clickAgreement:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnRegiste setBackgroundColor:[UIColor colorWithRed:199/255.0 green:0 blue:22/255.0 alpha:1]];
    _btnRegiste.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:1.0];
    
    [_btnQQLogin addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnWXLogin addTarget:self action:@selector(wxLoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnRegiste addTarget:self action:@selector(registeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickLogin{
    NSArray *controllers = [self.navigationController viewControllers];
    for (UIViewController *controller in controllers){
        if ([controller isKindOfClass:[ShopLoginViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    ShopLoginViewController *loginVC = [[ShopLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)clickAgreement:(UIButton *)sender{
    
    // @"服务协议"
    NSString *registeVC_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"registeVC_webView_navTitle"];
    //服务协议
    MyWebView *myWebView = [[MyWebView alloc] init];
    myWebView.navTitle = registeVC_webView_navTitle;
    myWebView.loadUrl = url_service_agreement;
    [self.navigationController pushViewController:myWebView animated:YES];
}

//密码是否可见
- (void)showPasswordOrNot:(UITextField *)text{
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    _eyeBtn.selected = !_eyeBtn.selected;
}

@end
