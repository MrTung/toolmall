//
//  UserNameViewController.m
//  eshop
//
//  Created by mc on 16/4/11.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UserNameViewController.h"

@interface UserNameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super addNavBackButton];

    // @"修改用户名"
    NSString *userNameVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"userNameVC_navItem_title"];
    // 提醒：用户名仅能修改一次
    NSString *userNameVC_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"userNameVC_label_title"];
    // 确认修改
    NSString *userNameVC_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"userNameVC_btn_title"];
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    nTitle.text = userNameVC_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
    self.label.text = userNameVC_label_title;
    [_btnSureAlter setTitle:userNameVC_btn_title forState:(UIControlStateNormal)];
    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"fav_close"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickTxtOfTextField:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 0, 40, 30);
//    _txtUserName.rightViewMode = UITextFieldViewModeAlways;
//    _txtUserName.rightView = button;
    _txtUserName.text = _user.name;
    _txtUserName.textBlank = 5;
    _txtUserName.layer.cornerRadius = 2;
    _txtUserName.layer.masksToBounds = YES;
    
    _btnSureAlter.layer.cornerRadius = 2;
    _btnSureAlter.layer.masksToBounds = YES;
    if (_user.userNameChanged == 1) {
        _txtUserName.enabled = NO;
        _btnSureAlter.hidden = YES;
    }
    else{
        _txtUserName.enabled = NO;
        _btnSureAlter.hidden = YES;
    }
    
    userinfo = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
}

- (void)clickTxtOfTextField:(UIButton *)button{
    _txtUserName.text = @"";
}

- (IBAction)sureToAlterUserName:(UIButton *)sender {
    if (_user.userNameChanged == 1) {
        sender.enabled = NO;
    }else{
        sender.enabled = YES;
        if (_txtUserName.text != nil) {
                [userinfo userChangeUserName:_txtUserName.text];
        }
    }
}

- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    if ([url isEqualToString:api_member_change_username]) {
        
        StatusResponse * respobj = (StatusResponse *)response;
        if (respobj.status.succeed == 1) {
            [CommonUtils ToastNotification:dosuccessed andView:self.view andLoading:YES andIsBottom:YES];
            
        [[Config Instance] saveUserInfo:@"uname" withvalue:_txtUserName.text];
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
