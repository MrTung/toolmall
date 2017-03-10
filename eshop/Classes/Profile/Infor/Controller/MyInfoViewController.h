//
//  MyInfoViewController.h
//  eshop
//
//  Created by mc on 16/4/11.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "UserNameViewController.h"
#import "USER.h"
#import "MyWebView.h"
#import "AccountSecurityViewController.h"

@interface MyInfoViewController : UIBaseController<ServiceResponselDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

{
    UserInfoService * userinfo;
    UIImagePickerController *ipc;
}

@property (strong, nonatomic) IBOutlet UIButton *btnHeadImage;
@property (strong, nonatomic) IBOutlet UIButton *btnUserName;
@property (strong, nonatomic) IBOutlet UIButton *btnSex;
@property (strong, nonatomic) IBOutlet UIButton *btnBirthday;


@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblSex;
@property (strong, nonatomic) IBOutlet UILabel *lblBirthday;
@property (strong, nonatomic) IBOutlet UILabel *lbVersionNO;
@property (strong, nonatomic) USER * user;
@property (strong, nonatomic) IBOutlet UIButton *btnQuit;

@property (strong, nonatomic) NSString * fieldName; //用来区别请求字段的类型
@property (strong, nonatomic) NSString * fieldValue; //请求的参数值
@property NSArray * sexArray;
@property NSArray * imageArray;
@end
