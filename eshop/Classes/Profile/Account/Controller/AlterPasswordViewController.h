//
//  AlterPasswordViewController.h
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"

#import "UserInfoService.h"
#import "LXFTextField.h"
@interface AlterPasswordViewController : UIBaseController<ServiceResponselDelegate>
{

    UserInfoService * userInfoService;
}
@property (strong, nonatomic) USER * user;
@property (strong, nonatomic) IBOutlet LXFTextField *txtNewPwd1;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPwd2;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@end
