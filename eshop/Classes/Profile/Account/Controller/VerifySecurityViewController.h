//
//  VerifySecurityViewController.h
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"

#import "UserInfoService.h"
#import "AlterPasswordViewController.h"

@interface VerifySecurityViewController : UIBaseController<ServiceResponselDelegate>

{
    UserInfoService * userInfoService;
}

@property (strong, nonatomic) USER * user;
@property (strong, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnVerifyCode;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (nonatomic, assign) NSInteger secondsCountDown; //倒计时时间
//@property (nonatomic, strong) NSTimer * countDownTimer; //计时器
@property NSString * aNewNumber;
@property BOOL isPushedFromNewMobilePage;

@end
