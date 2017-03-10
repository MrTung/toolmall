//
//  ImproveInfoViewController.h
//  eshop
//
//  Created by mc on 16/4/26.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "LXFTextField.h"
#import "RadioButton.h"
#import "KSDatePicker.h"
#import "ImproveInfoViewController.h"
#import "RegionSelector.h"
#import "AppMemberMoreUpdateRequest.h"
#import "UserInfoService.h"
#import "CouponCodeList.h"
#import "PBAlertController.h"

@interface ImproveInfoViewController : UIBaseController<ServiceResponselDelegate,RadioButtonDelegate,PBAlertControllerDelegate>
{
    STPopupController *popupController;
    int areaId;
    NSDate *birthday;
    UserInfoService *userInfoService;
}

@property (nonatomic, strong) NSMutableDictionary * dic;

@property (weak, nonatomic) IBOutlet LXFTextField *txtUserName;
@property (weak, nonatomic) IBOutlet LXFTextField *txtBirthday;
@property (weak, nonatomic) IBOutlet LXFTextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextView *txtviewAddress;

@property (nonatomic, strong) UIButton * btnSelectBirthday;
@property (nonatomic, strong) UIButton * btnSelectAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnBirthday;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnCommit;




@end
