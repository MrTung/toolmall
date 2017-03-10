//
//  AddressController.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AddressController.h"

#import "UIFont+Fit.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface AddressController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopLayoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIImageView *defaultClickImg;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@end

@implementation AddressController{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@synthesize consignee;
@synthesize tel;
@synthesize zipCode;
@synthesize area;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    addressService = [[AddressService alloc] initWithDelegate:self parentView:self.view];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;
    [super addNavBackButton];
    
    [self setTextValue];
//    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    nTitle.textAlignment = NSTextAlignmentCenter;
//    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
//    nTitle.font = [UIFont systemFontOfSize:20];
//    self.navigationItem.titleView = nTitle;
//    
//    self.navigationItem.title = addressList_navItem_title;
//    self.addressTextView.clearsOnInsertion = YES;
//    [self.consignee becomeFirstResponder];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAddressTextView:)];
    [self.addressTextView addGestureRecognizer:tap];
    
    if ([_mode isEqualToString:@"edit"]){
        
        // @"保存"
        NSString *addressController_btnEditSave_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_btnEditSave_title"];
        // @"修改地址"
        NSString *addressController_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_navItem_title"];
        btnEditSave = [[UIButton alloc] initWithFrame:CGRectMake(0, TMScreenH *0/568, TMScreenW, TMScreenH *36/568)];
        [btnEditSave setTitle:addressController_btnEditSave_title forState:UIControlStateNormal];
        btnEditSave.backgroundColor = redColorSelf;
        btnEditSave.tag = 2;
        [btnEditSave addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btnEditSave];
    
        self.navigationItem.title = addressController_navItem_title;
        self.consignee.text = _editAddress.consignee;
        self.tel.text = _editAddress.tel;
        self.zipCode.text = _editAddress.zipcode;
        [self.area setTitle:_editAddress.areaName forState:UIControlStateNormal];
        self.addressTextView.text = _editAddress.address;
        [self.area setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.addressTextView setTextColor:[UIColor blackColor]];
        areaId = _editAddress.area;
        if (_editAddress.isDefault) {
            [self.view5 removeFromSuperview];
        }
    } else {
        
        // @"保存"
        NSString *addressController_btnNewSave_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_btnNewSave_title"];
        // @"新增地址"
        NSString *addressController_navItem2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_navItem2_title"];
        
        btnNewSave = [[UIButton alloc] initWithFrame:CGRectMake(0, TMScreenH *0/568, TMScreenW, TMScreenH *36/568)];
        [btnNewSave setTitle:addressController_btnNewSave_title forState:UIControlStateNormal];
        btnNewSave.backgroundColor = redColorSelf;
        btnNewSave.tag = 1;
        btnNewSave.titleLabel.font = [UIFont boldSystemFontWithSize:16];
        [btnNewSave addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btnNewSave];
        [self.view5 removeFromSuperview];
        self.navigationItem.title = addressController_navItem2_title;
    }
    [super addThreedotButton];
    
    [self refreshUI];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
}

- (void)refreshUI {
    
    CGFloat height = TMScreenH - 113;
    self.labelHeightLayoutConstraint.constant = TMScreenH *36/568;
    self.textViewTopLayoutConstraint.constant = height *5/568;
    [self.view updateConstraints];
   
}

- (void)clearAddressTextView:(UITapGestureRecognizer *)tap{
    
    // 请输入详细地址（5-120字）
    NSString *addressController_addressTextView_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_addressTextView_plaTitle"];
    if ([self.addressTextView.text isEqualToString:addressController_addressTextView_plaTitle]) {
        
        self.addressTextView.text = @"";
    }
    [self.addressTextView becomeFirstResponder];
//    [self.area setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.addressTextView setTextColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_address_add]){
        Status * status = (Status *)response;
        if (status.succeed == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ([url isEqual:api_address_update]){
        Status * status = (Status *)response;
        if (status.succeed == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ([url isEqual:api_address_delete]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else if ([url isEqual:api_address_setdefault]){
        Status *status = (Status*)response;
        if (status.succeed == 1){
            // @"操作成功"
            NSString *addressController_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_toastNotification_msg1"];
            [CommonUtils ToastNotification:addressController_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
            self.defaultClickImg.image = [UIImage imageNamed:@"click1.png"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>= textField.tag){
        return NO;
    }
    return YES;
    
}

- (IBAction)clickButtons:(UIButton*)sender{
    if (sender.tag == 1){
        //新增保存
        if (![self saveValidate]){
            return;
        }
        [addressService addAddress:self.consignee.text tel:self.tel.text mobile:self.tel.text zipcode:self.zipCode.text address:self.addressTextView.text area:areaId];
    } else if (sender.tag == 2){
        //修改保存
        if (![self saveValidate]){
            return;
        }
        if (_defaultBtn.selected) {
            //设为默认
            NSString *address_id = [[NSString alloc] initWithFormat:@"%d", _editAddress.id];
            [addressService addressDefault:address_id];
        }
        NSString *address_id = [[NSString alloc] initWithFormat:@"%d", _editAddress.id];
        [addressService addressUpdate: address_id consignee:self.consignee.text tel:self.tel.text mobile:self.tel.text zipcode:self.zipCode.text address:self.addressTextView.text area:areaId];
    } else if (sender.tag == 3){
        
        // @"提示"
        NSString *addressController_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_alert_title"];
        // @"确定删除?"
        NSString *addressController_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_alert_msg"];
        //删除
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:addressController_alert_title
                                                        message:addressController_alert_msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];

    } else if (sender.tag == 4){
        //设为默认
        NSString *address_id = [[NSString alloc] initWithFormat:@"%d", _editAddress.id];
        [addressService addressDefault:address_id];
    } else if (sender.tag == 5){
        
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            self.defaultClickImg.image = [UIImage imageNamed:@"click1.png"];
        } else {
            self.defaultClickImg.image = [UIImage imageNamed:@"unclick1.png"];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSString *address_id = [[NSString alloc] initWithFormat:@"%d", _editAddress.id];
        [addressService addressDelete:address_id];
    }
}

- (IBAction)selectArea:(id)sender{
    RegionSelector *regionSelector = [[RegionSelector alloc] initWithNibName:@"RegionSelector" bundle:nil];
    regionSelector.regionDelegate = self;
    popupController = [[STPopupController alloc] initWithRootViewController:regionSelector];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}
- (void)regionSelected:(int)regionId areaName:(NSString*)regionName{
    
    [self.area setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.area setTitle:regionName forState:UIControlStateNormal];
    areaId = regionId;
    [popupController popViewControllerAnimated:YES];
}

- (Boolean)saveValidate{
    
    // @"请输入收货人姓名"
    NSString *addressController_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_toastNotification_msg2"];
    // @"请输入电话号码"
    NSString *addressController_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_toastNotification_msg3"];
    // @"请选择地区"
    NSString *addressController_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_toastNotification_msg4"];
    // @"请输入详细地址"
    NSString *addressController_toastNotification_msg5 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_toastNotification_msg5"];
    // 请输入详细地址（5-120字）
    NSString *addressController_addressTextView_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_addressTextView_plaTitle"];
    if ([CommonUtils trim:self.consignee.text].length == 0){
//        [CommonUtils ToastNotification:addressController_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        [CommonUtils ToastNotification:addressController_toastNotification_msg2 andView:self.view];
        return false;
    }
    if ([CommonUtils trim:self.tel.text].length == 0){
        [CommonUtils ToastNotification:addressController_toastNotification_msg3 andView:self.view];
        return false;
    }
    if (areaId == nil){
        [CommonUtils ToastNotification:addressController_toastNotification_msg4 andView:self.view];
        return false;
    }
    if ([CommonUtils trim:self.addressTextView.text].length == 0 || [self.addressTextView.text isEqualToString:addressController_addressTextView_plaTitle]){
        [CommonUtils ToastNotification:addressController_toastNotification_msg5 andView:self.view];
        return false;
    }
    return true;
}


//- (void)textViewDidChange:(UITextView *)textView{
//    if ([self.lblAddress.text length] == 0) {
//        [self.lblAddress setHidden:NO];
//    }else{
//        [self.lblAddress setHidden:YES];
//    }
//}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if ([textView becomeFirstResponder]) {
////        textView.text = nil;
//    }
//    return YES;
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    if ([textView becomeFirstResponder]) {
////        textView.text = nil;
//    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField == self.address) {
//        textField.hidden = NO;
//    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField == self.address) {
//        textField.hidden = YES;
//    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSInteger tag = textField.tag;
    if (tag == 14){
        //新增保存
        //if (![self saveValidate]){
        //    return NO;
        //}
        //[addressService addAddress:self.consignee.text tel:self.tel.text mobile:self.tel.text zipcode:self.zipCode.text address:self.address.text area:areaId];
        //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    } else {
        //UITextField *nextField = [self.view viewWithTag:tag + 1];
        //[nextField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [self.consignee resignFirstResponder];
    [self.zipCode resignFirstResponder];
    [self.tel resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
 
    // 收货人
    NSString *addressController_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_label1_title"];
    // 手机号码
    NSString *addressController_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_label2_title"];
    // 所在地区
    NSString *addressController_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_label3_title"];
    // 详细地址
    NSString *addressController_label4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_label4_title"];
    // 设为默认地址
    NSString *addressController_label5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_label5_title"];
    // 请输入收货人
    NSString *addressController_consignee_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_consignee_plaTitle"];
    // 点击选择
    NSString *addressController_area_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_area_title"];
    // 请输入手机号码
    NSString *addressController_tel_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_tel_plaTitle"];
    // 请输入详细地址（5-120字）
    NSString *addressController_addressTextView_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressController_addressTextView_plaTitle"];
    self.consignee.placeholder = addressController_consignee_plaTitle;
    self.tel.placeholder = addressController_tel_plaTitle;
    [self.area setTitle:addressController_area_title forState:(UIControlStateNormal)];
    self.addressTextView.text = addressController_addressTextView_plaTitle;
    self.label1.text = addressController_label1_title;
    self.label2.text = addressController_label2_title;
    self.label3.text = addressController_label3_title;
    self.label4.text = addressController_label4_title;
    self.label5.text = addressController_label5_title;
    
    if (_editAddress.isDefault) {
        
        self.defaultClickImg.image = [UIImage imageNamed:@"click1.png"];
    } else {
        self.defaultClickImg.image = [UIImage imageNamed:@"unclick1.png"];
    }
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
