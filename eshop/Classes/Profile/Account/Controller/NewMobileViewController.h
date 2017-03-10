//
//  NewMobileViewController.h
//  eshop
//
//  Created by mc on 16/4/21.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"

#import "UserInfoService.h"
#import "VerifySecurityViewController.h"

@interface NewMobileViewController : UIBaseController<ServiceResponselDelegate>

{
    UserInfoService * userInfoService;
}
@property (strong, nonatomic) IBOutlet UITextField *txtNewNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) USER * user;

@end
