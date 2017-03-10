//
//  AlterPasswordViewController.m
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "AlterPasswordViewController.h"

#import "UIFont+Fit.h"
@interface AlterPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation AlterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"修改登录密码"
    NSString *alterPasswordVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_navItem_title"];
    // @"新密码"
    NSString *alterPasswordVC_txtNewPwd2_leftViewTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_txtNewPwd2_leftViewTitle"];
    // 请输入新的密码
    NSString *alterPasswordVC_txtNewPwd1_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_txtNewPwd1_plaTitle"];
    // 新密码
    NSString *alterPasswordVC_txtNewPwd2_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_txtNewPwd2_plaTitle"];
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    nTitle.text = alterPasswordVC_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
    [self addNavBackButton];
    [super addThreedotButton];
    
    UILabel * new = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    new.text = alterPasswordVC_txtNewPwd2_leftViewTitle;
    new.textAlignment = NSTextAlignmentCenter;
    new.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    new.font = [UIFont systemFontWithSize:13];
    _txtNewPwd2.leftViewMode = UITextFieldViewModeAlways;
    _txtNewPwd2.leftView = new;
    
    _txtNewPwd1.placeholder = alterPasswordVC_txtNewPwd1_plaTitle;
    _txtNewPwd2.placeholder = alterPasswordVC_txtNewPwd2_plaTitle;
    
    [CommonUtils addBorderOnUITextField:_txtNewPwd2];
    [CommonUtils addBorderOnUITextField:_txtNewPwd1];
    _txtNewPwd1.textBlank = 10;
    [CommonUtils addBorderOnButton:_btnNext];
    
    userInfoService = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
    
    [self setTextValue];
}


- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    if ([url isEqualToString:api_password_resetviaapp]) {
        StatusResponse * respobj = (StatusResponse *)response;
        if (respobj.status.succeed == 1) {
            // @"恭喜您，登录密码修改成功"
            NSString *alterPasswordVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_toastNotification_msg1"];
            [CommonUtils ToastNotification:alterPasswordVC_toastNotification_msg1 andView:self.view andLoading:YES andIsBottom:YES];
            
            NSArray * controllerArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[controllerArray objectAtIndex:0] animated:YES];
        }
    }
}

- (IBAction)clickNextStepButton:(id)sender {
    
    // @"您还未输入新密码"
    NSString *alterPasswordVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_toastNotification_msg2"];
    // @"抱歉，两次密码不一样，请重新输入"
    NSString *alterPasswordVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_toastNotification_msg3"];
    if (_txtNewPwd1.text.length <1 || _txtNewPwd2.text.length <1) {
        [CommonUtils ToastNotification:alterPasswordVC_toastNotification_msg2 andView:self.view andLoading:YES andIsBottom:YES];
    }
   else if (![_txtNewPwd1.text isEqualToString:_txtNewPwd2.text]) {
        [CommonUtils ToastNotification:alterPasswordVC_toastNotification_msg3 andView:self.view andLoading:YES andIsBottom:YES];
    }else{
        [userInfoService userChangePassword:_txtNewPwd2.text];
    }
}


- (void)addNavBackButton{
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [left addTarget:self action:@selector(popToMyIfoPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)popToMyIfoPage:(UIButton *)button{
    
    NSArray * array = self.navigationController.viewControllers;
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 请输入新的密码:
    NSString *alterPasswordVC_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_label1_title"];
    // 密码由6-20位英文字母、数字或符号组成
    NSString *alterPasswordVC_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"alterPasswordVC_label2_title"];
    self.label1.text = alterPasswordVC_label1_title;
    self.label2.text = alterPasswordVC_label2_title;
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
