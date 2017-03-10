//
//  AccountSecurityViewController.h
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "AlterPasswordViewController.h"
#import "VerifySecurityViewController.h"
#import "NewMobileViewController.h"
#import "GetVerifyCodeViewController.h"
@interface AccountSecurityViewController : UIBaseController

@property (strong, nonatomic) IBOutlet UIButton *btnAlterPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnVerifyNumber;

@property (strong, nonatomic) USER * user;
@end
