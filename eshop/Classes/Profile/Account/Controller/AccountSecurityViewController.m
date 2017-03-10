//
//  AccountSecurityViewController.m
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "AccountSecurityViewController.h"

@interface AccountSecurityViewController ()

@property (weak, nonatomic) IBOutlet UILabel *view1Label1;
@property (weak, nonatomic) IBOutlet UILabel *view1Label2;

@property (weak, nonatomic) IBOutlet UILabel *view2Label1;
@property (weak, nonatomic) IBOutlet UILabel *view2Label2;

@end

@implementation AccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // @"账户安全"
    NSString *accountSecurityVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"accountSecurityVC_navItem_title"];
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = accountSecurityVC_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
    [super addNavBackButton];
    [super addThreedotButton];
    _lblPhoneNumber.text  = [CommonUtils changeMobileNumberFormatter:_user.mobile];
    
    [self setTextValue];
}

//修改登录密码 -> 先进入获取短信验证，然后进入修改密码页
- (IBAction)clickAlterPasswordButton:(id)sender {
    GetVerifyCodeViewController * p= [[GetVerifyCodeViewController alloc] initWithNibName:@"GetVerifyCodeViewController" bundle:nil];

//    VerifySecurityViewController * p = [[VerifySecurityViewController alloc] initWithNibName:@"VerifySecurityViewController" bundle:nil];
    p.user = _user;
    [self.navigationController pushViewController:p animated:YES];
}

//修改手机 -> 修进入新手机页面，然后进入验证页面
- (IBAction)clickVerifyNumberButton:(id)sender {
    NewMobileViewController * p = [[NewMobileViewController alloc] initWithNibName:@"NewMobileViewController" bundle:nil];
    p.user = _user;
    [self.navigationController pushViewController:p animated:YES];
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {

    // 登录密码
    NSString *accountSecurityVC_view1_label1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"accountSecurityVC_view1_label1"];
    // *建议您定期修改密码，以加强密码安全
    NSString *accountSecurityVC_view1_label2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"accountSecurityVC_view1_label2"];
    // 手机验证
    NSString *accountSecurityVC_view2_label1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"accountSecurityVC_view2_label1"];
    // *若您的验证手机已更换或停用，请及时修改更换
    NSString *accountSecurityVC_view2_label2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"accountSecurityVC_view2_label2"];
    
    self.view1Label1.text = accountSecurityVC_view1_label1;
    self.view1Label2.text = accountSecurityVC_view1_label2;
    self.view2Label1.text = accountSecurityVC_view2_label1;
    self.view2Label2.text = accountSecurityVC_view2_label2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
