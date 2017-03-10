//
//  VerifySecurityViewController.m
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "VerifySecurityViewController.h"

@interface VerifySecurityViewController ()

@end

@implementation VerifySecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"安全校验"
    NSString *verifySecurityVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_navItem_title"];
    // @"校验码"
    NSString *verifySecurityVC_txtVerifyCode_leftViewTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_txtVerifyCode_leftViewTitle"];
    // @"校验码"
    NSString *verifySecurityVC_txtVerifyCode_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_txtVerifyCode_plaTitle"];
    // @"%@，您好！"
    NSString *verifySecurityVC_lblUserName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_lblUserName_title"];
    // 下一步
    NSString *verifySecurityVC_btnNext_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_btnNext_title"];
    [super addNavTitle:verifySecurityVC_navItem_title];
    [super addNavBackButton];
    [super addThreedotButton];
    
    UILabel * new = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    new.text = verifySecurityVC_txtVerifyCode_leftViewTitle;
    new.textAlignment = NSTextAlignmentCenter;
    new.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    new.font = [UIFont systemFontOfSize:13];
    
    _txtVerifyCode.leftViewMode = UITextFieldViewModeAlways;
    _txtVerifyCode.leftView = new;
    _txtVerifyCode.placeholder = verifySecurityVC_txtVerifyCode_plaTitle;
    [_btnNext setTitle:verifySecurityVC_btnNext_title forState:(UIControlStateNormal)];
    [CommonUtils addBorderOnButton:_btnNext];
    [CommonUtils addBorderOnUITextField:_txtVerifyCode];
    [CommonUtils addBorderOnButton:_btnVerifyCode];
    
    _lblUserName.text = [NSString stringWithFormat:verifySecurityVC_lblUserName_title,_user.name];
    
    _btnVerifyCode.layer.borderWidth = 0.5;
    _btnVerifyCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated{
//    在这里判断下！如果是从修改手机号码页面推出来的，那么，我们将新手机号码作为参数传过去。
//    否则我们将旧手机号码传过去，来获取验证码，验证后跳到修改密码页面
    userInfoService = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
    [self getVerifyCode];
//    _isPushedFromNewMobilePage ?  [userInfoService getSmsAuthCode:_aNewNumber] : [userInfoService getSmsAuthCode:_user.mobile];
}

//获取验证码
- (void)getVerifyCode{
    
    // 我们已经发送了校验码到您的手机上:
    NSString *verifySecurityVC_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_label_title"];
    if (!_isPushedFromNewMobilePage) {
        [userInfoService getSmsAuthCode:_user.mobile chkMobileExist:@"N"];
        _lblDesc.text = [verifySecurityVC_label_title stringByAppendingString:[CommonUtils changeMobileNumberFormatter:_user.mobile]];
    }else {
        [userInfoService getSmsAuthCode:_aNewNumber chkMobileExist:@"N"];
        _lblDesc.text = [verifySecurityVC_label_title stringByAppendingString:[CommonUtils changeMobileNumberFormatter:_aNewNumber]];
    }
}

- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    if ([url isEqualToString:api_getSmsAuthCode]) {
        
        SmsAuthCodeResponse *smsAuthCodeResponse = (SmsAuthCodeResponse *)response;
        Status *status = smsAuthCodeResponse.status;
        if (status.succeed == 1){
            
//            NSLog(@"%2d",smsAuthCodeResponse.data.countDown);
            _secondsCountDown = 120;
            [self startTime];
        }
    }
    
    else if ([url isEqualToString:api_smsauthcode_verifySmsAuthCode]) {
        StatusResponse * respobj = (StatusResponse *)response;
        
        // @"恭喜您，修改手机成功"
        NSString *verifySecurityVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_toastNotification_msg1"];
        // @"抱歉，您的验证码有误"
        NSString *verifySecurityVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_toastNotification_msg2"];
        
        if (respobj.status.succeed) {
            if (_isPushedFromNewMobilePage) {
                [CommonUtils ToastNotification:verifySecurityVC_toastNotification_msg1 andView:self.view andLoading:YES andIsBottom:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                AlterPasswordViewController * pass = [[AlterPasswordViewController alloc] initWithNibName:@"AlterPasswordViewController" bundle:nil];
                pass.user = _user;
                [self.navigationController pushViewController:pass animated:YES];
            }
        }
        else {
            [CommonUtils ToastNotification:verifySecurityVC_toastNotification_msg2 andView:self.view andLoading:YES andIsBottom:YES];
        }
    }
}


//验证码倒计时
-(void)startTime{
    __block int timeout=_secondsCountDown; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        // @"重新获取"
        NSString *verifySecurityVC_btnVerifyCode_title1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_btnVerifyCode_title1"];
        // @"重新获取(%@)"
        NSString *verifySecurityVC_btnVerifyCode_title2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_btnVerifyCode_title2"];
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnVerifyCode setTitle:verifySecurityVC_btnVerifyCode_title1 forState:UIControlStateNormal];
//                [_btnVerifyCode setTitle:@"重新获取" forState:UIControlStateHighlighted];
                _btnVerifyCode.userInteractionEnabled = YES;
            });
        }else{
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.3d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_btnVerifyCode setTitle:[NSString stringWithFormat:verifySecurityVC_btnVerifyCode_title2,strTime] forState:UIControlStateNormal];
//                 [_btnVerifyCode setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateHighlighted];
                [UIView commitAnimations];
                _btnVerifyCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



//下一步按钮
- (IBAction)clickNextStepButton:(id)sender {
    if (_txtVerifyCode.text == nil || [_txtVerifyCode.text isEqualToString:@""]) {
        // @"您还为输入验证码"
        NSString *verifySecurityVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"verifySecurityVC_toastNotification_msg3"];
        [CommonUtils ToastNotification:verifySecurityVC_toastNotification_msg3 andView:self.view andLoading:YES andIsBottom:YES];
    }
    else{
        if (!_isPushedFromNewMobilePage) {
            [userInfoService userVerifySmsAuthCode:_txtVerifyCode.text mobileNo:_user.mobile];
        }
        else {
            [userInfoService userVerifySmsAuthCode:_txtVerifyCode.text mobileNo:_aNewNumber];
        }
    }
}

//重新获取验证码
- (IBAction)clickRegetVerifyCodeButton:(id)sender {
    [self getVerifyCode];
}



//- (void)addNavBackButton{
//    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.frame = CGRectMake(0, 2, 44, 40);
//    [left setImage:[UIImage imageNamed:@"mynewback.png"] forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"mynewback.png"] forState:UIControlStateHighlighted];
//    [left addTarget:self action:@selector(popToMyIfoPage) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBarHidden = NO;
//}
//
//- (void)popToMyIfoPage{
//    NSArray * array = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
