//
//  AddressController.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressService.h"
#import "AddressAddRequest.h"
#import "AddressUpdateRequest.h"
#import "Address.h"
#import "StatusResponse.h"
#import "RegionSelector.h"
@interface AddressController : UIBaseController<UITextFieldDelegate, RegionSelectorDelegate, UIAlertViewDelegate,UITextViewDelegate>{
    AddressService *addressService;
    int areaId;
    STPopupController *popupController;
    
    UIButton *btnNewSave;
    UIButton *btnEditSave;
    UIButton *btnSetDefault;
    UIButton *btnDel;
}

@property (nonatomic) IBOutlet UITextField *consignee;
@property (nonatomic) IBOutlet UITextField *tel;
@property (nonatomic) IBOutlet UITextField *zipCode;
@property (nonatomic) IBOutlet UIButton *area;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;

@property (nonatomic) IBOutlet UIView *btnView;
@property NSString *mode;
@property Address *editAddress;

@end
