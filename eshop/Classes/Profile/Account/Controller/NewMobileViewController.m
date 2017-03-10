//
//  NewMobileViewController.m
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "NewMobileViewController.h"

@interface NewMobileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NewMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // @"修改手机"
    NSString *newMobileVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_navItem_title"];
    // @"手机号"
    NSString *newMobileVC_txtNewNumber_leftViewTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_txtNewNumber_leftViewTitle"];
    // 新手机号
    NSString *newMobileVC_txtNewNumber_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_txtNewNumber_plaTitle"];
    // 请输入新的手机号码:
    NSString *newMobileVC_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_label_title"];
    // 下一步
    NSString *newMobileVC_btnNext_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_btnNext_title"];
    [super addNavTitle:newMobileVC_navItem_title];
    [super addNavBackButton];
    [super addThreedotButton];
    
    self.label.text = newMobileVC_label_title;
    
    UILabel * new = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    new.text = newMobileVC_txtNewNumber_leftViewTitle;
    new.textAlignment = NSTextAlignmentCenter;
    new.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    new.font = [UIFont systemFontOfSize:13];
    _txtNewNumber.leftViewMode = UITextFieldViewModeAlways;
    _txtNewNumber.leftView = new;
    _txtNewNumber.placeholder = newMobileVC_txtNewNumber_plaTitle;
    
    [_btnNext setTitle:newMobileVC_btnNext_title forState:(UIControlStateNormal)];
    [CommonUtils addBorderOnButton:_btnNext];
    [CommonUtils addBorderOnUITextField:_txtNewNumber];
    
    userInfoService = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
}

//跳转到下一页
- (IBAction)clickNextStepButton:(id)sender {
    
    // @"抱歉，您的手机号输入有误"
    NSString *newMobileVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_toastNotification_msg1"];
    // @"您还未输入新手机号码"
    NSString *newMobileVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"newMobileVC_toastNotification_msg2"];
    if (_txtNewNumber.text.length == 11) {
        [userInfoService userChangeMobileNo:_txtNewNumber.text oldMobileNo:_user.mobile];
    }else if (_txtNewNumber.text.length != 11 && _txtNewNumber.text.length > 0){
        [CommonUtils ToastNotification:newMobileVC_toastNotification_msg1 andView:self.view andLoading:YES andIsBottom:YES];
    }else if (_txtNewNumber == nil || [_txtNewNumber.text  isEqual: @""]){
        [CommonUtils ToastNotification:newMobileVC_toastNotification_msg2 andView:self.view andLoading:YES andIsBottom:YES];
    }
    

}

- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    if ([url isEqualToString:api_member_changemobileno]) {
        StatusResponse * respobj = (StatusResponse *)response;
        
//        NSLog(@"%@",respobj);
        
        if (respobj.status.succeed ==1) {
            
            VerifySecurityViewController * p = [[VerifySecurityViewController alloc] initWithNibName:@"VerifySecurityViewController" bundle:nil];
            p.user = _user;
            p.isPushedFromNewMobilePage = YES;
            p.aNewNumber = _txtNewNumber.text;
            [self.navigationController pushViewController:p animated:YES];
        }
    }

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
