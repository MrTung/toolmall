//
//  FirmMobileViewController.m
//  eshop
//
//  Created by mc on 16/1/27.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "FirmMobileViewController.h"



@interface FirmMobileViewController ()

@property (nonatomic, assign) NSInteger secondsCountDown; //倒计时时间

@end

@implementation FirmMobileViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self.navigationItem setHidesBackButton:YES];
        
        userInfoService = [[UserInfoService alloc]initWithDelegate:self parentView:self.view];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = kBGColor;
    
    [self Nav];
    [self UI];

    
    //  添加手势，触摸文本框其他位置，键盘下去
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown)];
    [self.view addGestureRecognizer:clickGesture];
    
}

#pragma 导航栏
- (void)Nav{
    
    // @"快速绑定手机"
    NSString *firmMobile_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_navItem_title"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = firmMobile_navItem_title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 30, 30);
    [left setImage:[UIImage imageNamed:@"newback1.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backRoot:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)backRoot:(UIBarButtonItem *)item{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma 页面内容布局
- (void)UI{
    
    // @"请输入手机号"
    NSString *firmMobile_txtPhoneNumber_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_txtPhoneNumber_plaTitle"];
    // @"请输入短信验证码"
    NSString *firmMobile_txtMessageCode_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_txtMessageCode_plaTitle"];
    // @"获取验证码"
    NSString *firmMobile_btnMessageCode_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_btnMessageCode_plaTitle"];
    
    // @"请设置登录密码"
    NSString *firmMobile_txtPassword_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_txtPassword_plaTitle"];
    // @"注册即视为同意"
    NSString *firmMobile_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_label_title"];
    // @"《土猫网用户注册协议》"
    NSString *firmMobile_lblProtocol_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_lblProtocol_title"];
    // @"立即绑定"
    NSString *firmMobile_btnFirmNow_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_btnFirmNow_title"];
    // @"绑定手机后，您可以用绑定手机快捷登录"
    NSString *firmMobile_lblDescription_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_lblDescription_title"];
    _txtPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(kBorder,
                                                                   kTextHeight / 2.0,
                                                                   kWidth - 2*kBorder,
                                                                   kTextHeight)];
    _txtPhoneNumber.placeholder = firmMobile_txtPhoneNumber_plaTitle;
    _txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    _txtPhoneNumber.delegate = self;
    _txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_txtPhoneNumber addTarget:self action:@selector(limitedNumber:) forControlEvents:UIControlEventEditingChanged];
    
    
//  输入短信文本框
    _txtMessageCode = [[UITextField alloc]initWithFrame:CGRectMake(kBorder,
                                                                     CGRectGetMaxY(_txtPhoneNumber.frame) + kBorder - 5,
                                                                     (kWidth - 3*kBorder) /3.0 * 2,
                                                                     kTextHeight)];
    _txtMessageCode.keyboardType = UIKeyboardTypePhonePad;
    _txtMessageCode.placeholder = firmMobile_txtMessageCode_plaTitle;
    [_txtMessageCode addTarget: self action:@selector(limitedNumber:) forControlEvents:UIControlEventEditingChanged];
    
//    设置请求短信验证码的按钮
    _btnMessageCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMessageCode.frame = CGRectMake(CGRectGetMaxX(_txtMessageCode.frame)+kBorder,
                                   CGRectGetMinY(_txtMessageCode.frame),
                                   (kWidth - 3*kBorder)/3.0,
                                   kTextHeight);
    [_btnMessageCode setTitle:firmMobile_btnMessageCode_plaTitle forState:UIControlStateNormal];
    [_btnMessageCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btnMessageCode.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_btnMessageCode addTarget:self action:@selector(reqMessageCode:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnMessageCode.layer.masksToBounds = YES;
    _btnMessageCode.layer.cornerRadius = 5;
    _btnMessageCode.layer.borderColor = kBorderColor.CGColor;
    _btnMessageCode.layer.borderWidth = 1;
    [self.view addSubview:_btnMessageCode];

//  设置密码文本框
    _txtPassword = [[UITextField alloc]initWithFrame:CGRectMake(kBorder,
                                                                CGRectGetMaxY(_txtMessageCode.frame) + kBorder - 5,
                                                                kWidth - 2*kBorder,
                                                                kTextHeight)];
    _txtPassword.placeholder = firmMobile_txtPassword_plaTitle;

    _txtPassword.secureTextEntry = YES;
    _txtPassword.rightViewMode = UITextFieldViewModeAlways;
    _txtPassword.delegate = self;

    
    UIButton * btnSee = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSee.frame = CGRectMake(0, 0, kTextHeight, 30);
    [btnSee setImage:[UIImage imageNamed:@"logineye.png"] forState:UIControlStateNormal];
    [btnSee addTarget:self action:@selector(showPasswordOrNot:) forControlEvents:UIControlEventTouchUpInside];
    _txtPassword.rightView = btnSee;

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kBorder,
                                                               CGRectGetMaxY(_txtPassword.frame) + kBorder - 5,
                                                               100,
                                                               kBorder)];
    
    label.font  = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor lightGrayColor];
    label.text =firmMobile_label_title;
    [self.view addSubview:label];
    
    //    用户注册协议
    _lblProtocol = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) ,CGRectGetMinY(label.frame), 140, kBorder)];
    _lblProtocol.userInteractionEnabled = YES;
    _lblProtocol.textAlignment = NSTextAlignmentLeft;
    _lblProtocol.text = firmMobile_lblProtocol_title;
    _lblProtocol.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:_lblProtocol];

//   立即绑定按钮
    _btnFirmNow = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFirmNow.frame = CGRectMake(kBorder ,
                                   CGRectGetMaxY(label.frame) + kBorder - 5,
                                   kWidth - 2*kBorder,
                                   kTextHeight);
    [_btnFirmNow setBackgroundColor:redColorSelf];
    [_btnFirmNow setTitle:firmMobile_btnFirmNow_title forState:UIControlStateNormal];
    [_btnFirmNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_btnFirmNow setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
    _btnFirmNow.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [_btnFirmNow addTarget:self action:@selector(firmMobileNow:) forControlEvents:UIControlEventTouchUpInside];
    _btnFirmNow.layer.masksToBounds = YES;
    _btnFirmNow.layer.cornerRadius = 5;
    [self.view addSubview:_btnFirmNow];
//
    _lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(_btnFirmNow.frame) + kBorder - 5,kWidth - 2*kBorder, 2*kBorder)];
    _lblDescription.text = firmMobile_lblDescription_title;
    _lblDescription.font = [UIFont systemFontOfSize:14.0f];
    _lblDescription.textColor = [UIColor redColor];
    [self.view addSubview:_lblDescription];
    
    
    [self change:_txtPhoneNumber];
    [self change:_txtMessageCode];
    [self change:_txtPassword];

//    重新赋背景色
    _btnMessageCode.backgroundColor = kBGColor;
    

    
}

//放下键盘
- (void)keybordDown{
    [_txtMessageCode resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtPhoneNumber resignFirstResponder];
}

#pragma  UITextFieldDelegate限制文本框的长度
- (void)limitedNumber :(UITextField *)textField{
    int number = (textField == _txtPhoneNumber) ? 11:6;
    if (textField.text.length > number) {
        textField.text = [textField.text substringToIndex:number];
    }
}

//密码是否可见
- (void)showPasswordOrNot:(UITextField *)text{
    text.secureTextEntry = !text.secureTextEntry;
}

// 加边框和圆角
- (void)change:(UITextField *)textField{

    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = kBorderColor.CGColor;
    textField.layer.borderWidth = 1;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:14];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, kHeight)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = view;
    
    textField.delegate = self;
    [self.view addSubview:textField];
    
}

// 获取短信验证码
- (void)reqMessageCode:(UIButton *)button {
    
    [_txtPhoneNumber resignFirstResponder];
    //向服务器端发送一个请求，获取一个短信验证码
    NSString * vMobilePhone = [CommonUtils trim:_txtPhoneNumber.text];
    if (vMobilePhone.length == 0){
        // @"请输入手机号"
        NSString *firmMobile_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_toastNotification_msg1"];
        [CommonUtils ToastNotification:firmMobile_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
//    NSLog(@"获取验证码");
    
    [userInfoService getSmsAuthCode:vMobilePhone chkMobileExist:nil];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
//    NSLog(@"url是：%@",url);
    if ([url isEqual: api_getSmsAuthCode]){
        SmsAuthCodeResponse *smsAuthCodeResponse = (SmsAuthCodeResponse *)response;
        Status *status = smsAuthCodeResponse.status;
        if (status.succeed == 1){
            
            _secondsCountDown = 120;
            
            [self startTime];
        }

    }
    
    else if ([url isEqual: api_bandmobile]){
        
        UserSignInResponse * respobj = (UserSignInResponse *)response;
        
        if (respobj.status.succeed == 1) {
            
            [[Config Instance] saveUserInfo:@"uid" withvalue:[[NSString alloc] initWithFormat:@"%d", respobj.data.user.id]];
            [[Config Instance] saveUserInfo:@"sid" withvalue:respobj.data.session.sid];
            [[Config Instance] saveUserInfo:@"uname" withvalue:respobj.data.user.name];
            [[Config Instance] saveUserInfo:@"key" withvalue:respobj.data.session.key];
            [[Config Instance] saveUserInfo:@"email" withvalue:respobj.data.user.email];
            [[Config Instance] saveUserInfo:@"memberrank" withvalue:respobj.data.user.rank_name];
            
            [[Config Instance] saveUserInfo:@"mobile" withvalue:respobj.data.user.mobile];
            
            [[Config Instance] saveCartId:respobj.data.session.cartId];
            [[Config Instance] saveCartToken:respobj.data.session.cartToken];
            
//            [SESSION setSession:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }
}


// 立即绑定按钮事件
- (void)firmMobileNow:(UIButton *)button {
    
    NSString * mobileNo = _txtPhoneNumber.text;
    NSString * authCode = _txtMessageCode.text;
    NSString * password = _txtPassword.text;

    [userInfoService userBondMobileNo:mobileNo authCode:authCode password:password session:[SESSION getSession]];
}




- (Boolean)saveValidate{
    
    NSString * vMobilePhone = [CommonUtils trim:_txtPhoneNumber.text];
    NSString * vMessageNo = [CommonUtils trim:_txtMessageCode.text];
    NSString * vPassword = [CommonUtils trim:_txtPassword.text];
    
    // @"请输入手机号"
    NSString *firmMobile_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_toastNotification_msg2"];
    // @"请输入短信验证码"
    NSString *firmMobile_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_toastNotification_msg3"];
    // @"请输入密码"
    NSString *firmMobile_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_toastNotification_msg4"];
    if (vMobilePhone.length == 0){
        [CommonUtils ToastNotification:firmMobile_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }
    if (vMessageNo.length == 0){
        [CommonUtils ToastNotification:firmMobile_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }
    if (vPassword.length == 0){
        [CommonUtils ToastNotification:firmMobile_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
        return false;
    }
    
    return true;
}

- (void)save{
    NSString *mobileNo = [CommonUtils trim:_txtPhoneNumber.text];
    NSString *authCode = [CommonUtils trim:_txtMessageCode.text];
    NSString *password = [CommonUtils trim:_txtPassword.text];
 
    [userInfoService userBondMobileNo:mobileNo authCode:authCode password:password session:[SESSION getSession]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField == _txtPassword){
        //新增保存
        if (![self saveValidate]){
            return NO;
        }
        [self save];
    }
    return YES;
}


-(void)startTime{
    
    __block int timeout=_secondsCountDown; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        // @"发送验证码"
        NSString *firmMobile_btnMessageCode1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_btnMessageCode1_title"];
        // @"重新获取%@"
        NSString *firmMobile_btnMessageCode2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"firmMobile_btnMessageCode2_title"];
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnMessageCode setTitle:firmMobile_btnMessageCode1_title forState:UIControlStateNormal];
                _btnMessageCode.userInteractionEnabled = YES;
            });
        }else{
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.3d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_btnMessageCode setTitle:[NSString stringWithFormat:firmMobile_btnMessageCode2_title,strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _btnMessageCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
