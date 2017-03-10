//
//  UserNameViewController.h
//  eshop
//
//  Created by mc on 16/4/11.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"

#import "UserInfoService.h"
#import "LXFTextField.h"

@interface UserNameViewController : UIBaseController<UIImagePickerControllerDelegate,ServiceResponselDelegate>

{
    UserInfoService * userinfo;
}

@property (strong, nonatomic) IBOutlet LXFTextField *txtUserName;
@property (strong, nonatomic) USER * user;
@property (strong, nonatomic) IBOutlet UIButton *btnSureAlter;

@end
