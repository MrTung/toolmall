//
//  ImproveInfoViewController.m
//  eshop
//
//  Created by mc on 16/4/26.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ImproveInfoViewController.h"

@interface ImproveInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;


@end

@implementation ImproveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    areaId = -1;
    
    // @"完善信息"
    NSString *improveInfoVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_navItem_title"];
    [super addNavBackButton];
    [super addThreedotButton];
    [super addNavTitle:improveInfoVC_navItem_title];

    userInfoService = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
//    [self UI];
    
    [self setTextValue];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self UI];
}

-(void)UI{
    [CommonUtils addBorderOnUITextField:_txtUserName];
    [CommonUtils addBorderOnUITextField:_txtBirthday];
    [CommonUtils addBorderOnUITextField:_txtAddress];
    [CommonUtils addBorderOnButton:_btnCommit];
    
    _txtviewAddress.layer.masksToBounds = YES;
    _txtviewAddress.layer.cornerRadius = 3;
    _txtviewAddress.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
    _txtviewAddress.layer.borderWidth = 1;
    
    
    _btnSelectBirthday = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btnSelectBirthday.backgroundColor = [UIColor cyanColor];
    _btnSelectBirthday.frame = CGRectMake(0, 0,  TMScreenH *20/568,  TMScreenH *20/568);
    [self.btnBirthday addTarget:self action:@selector(clickOnSelectBirthdayButton:) forControlEvents:UIControlEventTouchUpInside];
    [CommonUtils addBorderOnButton:_btnSelectBirthday];
    _txtBirthday.rightView = _btnSelectBirthday;
    _txtBirthday.rightViewMode = UITextFieldViewModeAlways;
    
    _btnSelectAddress = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btnSelectAddress.backgroundColor = [UIColor cyanColor];
    _btnSelectAddress.frame = CGRectMake(0, 0, TMScreenH *20/568, TMScreenH *20/568);
    [self.btnAddress addTarget:self action:@selector(clickOnSelectAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [CommonUtils addBorderOnButton:_btnSelectAddress];
    _txtAddress.rightView = _btnSelectAddress;
    _txtAddress.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView * image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arw_down"]];
    image1.frame = CGRectMake(TMScreenW *5/320,  TMScreenH *5/568, TMScreenW *10/320,  TMScreenH *10/568);
    UIImageView * image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arw_down"]];
    image2.frame = CGRectMake(TMScreenW *5/320,  TMScreenH *5/568, TMScreenW *10/320,  TMScreenH *10/568);
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(TMScreenW *1/320, 0, TMScreenW *1/320,  TMScreenH *20/568)];
    line1.backgroundColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(TMScreenW *1/320, 0, TMScreenW *1/320,  TMScreenH *20/568)];
    line2.backgroundColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    [_btnSelectBirthday addSubview:line1];
    [_btnSelectAddress addSubview:line2];
    [_btnSelectBirthday addSubview:image1];
    [_btnSelectAddress addSubview:image2];
    
    _txtBirthday.textBlank = TMScreenW *5/320;
    _txtAddress.textBlank = TMScreenW *5/320;
    _txtUserName.textBlank = TMScreenW *5/320;
    
    // 男
    NSString *improveInfoVC_radioButton_rb1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb1"];
    // 女
    NSString *improveInfoVC_radioButton_rb2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb2"];
    RadioButton *rb1 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_txtUserName.frame) - TMScreenW *3/320, CGRectGetMinY(_sexLabel.frame)- TMScreenH *5/568, TMScreenW *25/320, CGRectGetHeight(_sexLabel.frame) + TMScreenH *10/568) groupId:@"gender" index:0 text:improveInfoVC_radioButton_rb1];
    RadioButton *rb2 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rb1.frame)+ TMScreenW *20/320, CGRectGetMinY(rb1.frame), TMScreenW *25/320, CGRectGetHeight(rb1.frame)) groupId:@"gender" index:1 text:improveInfoVC_radioButton_rb2];
    
    [self.view addSubview:rb1];
    [self.view addSubview:rb2];
    
    // 企业采购
    NSString *improveInfoVC_radioButton_rb11 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb11"];
    // 五金个体户
    NSString *improveInfoVC_radioButton_rb12 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb12"];
    // 装修工人
    NSString *improveInfoVC_radioButton_rb13 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb13"];
    // 其他
    NSString *improveInfoVC_radioButton_rb14 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb14"];    RadioButton *rb11 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_txtviewAddress.frame) - TMScreenW *3/320, CGRectGetMinY(_jobLabel.frame) - TMScreenH *5/568, TMScreenW *25/320, CGRectGetHeight(rb1.frame)) groupId:@"occupation" index:0 text:improveInfoVC_radioButton_rb11];
    RadioButton *rb12 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rb11.frame) + TMScreenW *20/320, CGRectGetMinY(rb11.frame), TMScreenW *25/320, CGRectGetHeight(rb1.frame)) groupId:@"occupation" index:1 text:improveInfoVC_radioButton_rb12];
    RadioButton *rb13 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(rb11.frame), CGRectGetMaxY(rb11.frame) + TMScreenH *5/568, TMScreenW *25/320, CGRectGetHeight(rb1.frame)) groupId:@"occupation" index:2 text:improveInfoVC_radioButton_rb13];
    RadioButton *rb14 = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rb13.frame) + TMScreenW *20/320, CGRectGetMinY(rb13.frame), TMScreenW *25/320, CGRectGetHeight(rb1.frame)) groupId:@"occupation" index:3 text:improveInfoVC_radioButton_rb14];
    
    // 设置一个默认选项
    //    [rb11 setChecked:YES];
    [self.view addSubview:rb11];
    [self.view addSubview:rb12];
    [self.view addSubview:rb13];
    [self.view addSubview:rb14];
    
    [RadioButton addObserverForGroupId:@"gender" observer:self];
    [RadioButton addObserverForGroupId:@"occupation" observer:self];
    
    _dic = [[NSMutableDictionary alloc] initWithCapacity:16];
}


//选择生日
- (void)clickOnSelectBirthdayButton:(UIButton *)button{
    
    //x,y 值无效，默认是居中的
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
    picker.appearance.radius = 3;
    
    //设置回调
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        
        if (buttonType == KSDatePickerButtonCommit) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [self.txtBirthday setText:[formatter stringFromDate:currentDate]];
            birthday = currentDate;
        }
    };
    // 显示
    [picker show];
}

//选择地址
- (void)clickOnSelectAddressButton:(UIButton *)button{
    RegionSelector *regionSelector = [[RegionSelector alloc] initWithNibName:@"RegionSelector" bundle:nil];
    regionSelector.regionDelegate = self;
    popupController = [[STPopupController alloc] initWithRootViewController:regionSelector];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

//单选按钮代理方法
//-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId codeValue:(NSString *)codeValue{
//    
//    [_dic setObject:codeValue forKey:groupId];
//}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId{
        [_dic setObject:[NSString stringWithFormat:@"%d",index] forKey:groupId];
}
//地区选择
- (void)regionSelected:(int)regionId areaName:(NSString*)regionName{
    [self.txtAddress setText:regionName];
    areaId = regionId;
    [popupController popViewControllerAnimated:YES];
}
//提交信息
- (IBAction)clickCommitButton:(id)sender {
    
    NSString *userName = [CommonUtils trim:self.txtUserName.text];
    NSString *address = [CommonUtils trim:self.txtAddress.text];
    NSString *birth = [CommonUtils trim:self.txtBirthday.text];
    
    // @"请选择"
    NSString *improveInfoVC_txtBirthday_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_txtBirthday_plaTitle"];
    // @"男"
    NSString *improveInfoVC_radioButton_rb1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_radioButton_rb1"];
    // @"请输入用户名"
    NSString *improveInfoVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg1"];
    // @"请选择性别"
    NSString *improveInfoVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg2"];
    // @"请输入生日"
    NSString *improveInfoVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg3"];
    // @"请选择地址区域"
    NSString *improveInfoVC_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg4"];
    // @"请输入详细地址"
    NSString *improveInfoVC_toastNotification_msg5 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg5"];
    // @"请选择职业"
    NSString *improveInfoVC_toastNotification_msg6 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_toastNotification_msg6"];
    if (userName.length == 0){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if ([_dic objectForKey:@"gender"] == nil){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if (birth.length == 0 || [birth isEqualToString:improveInfoVC_txtBirthday_plaTitle]){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if (areaId == -1){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    
    if (address.length == 0){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg5 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if ([_dic objectForKey:@"occupation"] == nil){
        [CommonUtils ToastNotification:improveInfoVC_toastNotification_msg6 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    
    AppMemberMoreUpdateRequest *request = [[AppMemberMoreUpdateRequest alloc] init];
    request.userName = userName;
    request.gender = [[_dic objectForKey:@"gender"] isEqualToString:improveInfoVC_radioButton_rb1] ? @"male":@"female";
    request.areaId = areaId;
    request.address = address;
    request.birthday = birth;
    request.occupation = [_dic objectForKey:@"occupation"];
    request.session = [SESSION getSession];
    [userInfoService updateMore:request];
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_member_update_more]){
        UserSignInResponse * resp = (UserSignInResponse *)response;
        if (resp.status.succeed == 1){
            if (!resp.status.success_desc){
                [CommonUtils ToastNotification:resp.status.success_desc andView:self.view andLoading:NO andIsBottom:NO];
            }
            
            [[Config Instance] saveUserInfo:@"uid" withvalue:[[NSString alloc] initWithFormat:@"%d", resp.data.user.id]];
            [[Config Instance] saveUserInfo:@"sid" withvalue:resp.data.session.sid];
            [[Config Instance] saveUserInfo:@"uname" withvalue:resp.data.user.name];
            [[Config Instance] saveUserInfo:@"key" withvalue:resp.data.session.key];
            [[Config Instance] saveUserInfo:@"email" withvalue:resp.data.user.email];
            [[Config Instance] saveUserInfo:@"memberrank" withvalue:resp.data.user.rank_name];
            [[Config Instance] saveCartId:resp.data.session.cartId];
            [[Config Instance] saveCartToken:resp.data.session.cartToken];
            
            [SESSION setMobileNo:resp.data.user.mobile];
            [SESSION setIsUserNameChanged:true];
            [SESSION setSession:nil];

            if (resp.data.donateCoupon == true) {
                [self custom];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } 
}

//自定义
- (void)custom{
    
    PBAlertController * alertVc = [PBAlertController shareAlertController];
    alertVc.delegate = self;
    [alertVc alertViewControllerWithMessage:@"" andBlock:^{
    }];
    alertVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:alertVc animated:YES];
    
}

- (void)clickBtnCancel{
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBtnConfirm{
    CouponCodeList *couponCodeList = [[CouponCodeList alloc] initWithNibName:@"CouponCodeList" bundle:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;

    [self.navigationController pushViewController:couponCodeList animated:YES ];
    
}


//原生
- (void)alert{
    
    // @"提交成功，10元优惠券已经给您，是否前往优惠券列表查看？"
    NSString *improveInfoVC_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_alert_msg"];
    // @"去看看"
    NSString *improveInfoVC_alert_sure = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_alert_sure"];
    UIAlertController * c  =  [UIAlertController alertControllerWithTitle:nil message:improveInfoVC_alert_msg preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:improveInfoVC_alert_sure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CouponCodeList *couponCodeList = [[CouponCodeList alloc] initWithNibName:@"CouponCodeList" bundle:nil];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        
        [self.navigationController pushViewController:couponCodeList animated:YES];
        
    }];
    
    
    [c addAction:cancelAction];
    [c addAction:otherAction];
    
    [self presentViewController:c animated:YES completion:^{
    }];
    
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 完善信息，获得10元券
    NSString *improveInfoVC_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_label1_title"];
    // 用户名:
    NSString *improveInfoVC_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_label2_title"];
    // 用户名仅支持修改一次。
    NSString *improveInfoVC_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_label3_title"];
    // 性别:
    NSString *improveInfoVC_sexLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_sexLabel_title"];
    // 生日:
    NSString *improveInfoVC_label4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_label4_title"];
    // 地址:
    NSString *improveInfoVC_label5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_label5_title"];
    // 职业:
    NSString *improveInfoVC_jobLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_jobLabel_title"];
    // 请选择
    NSString *improveInfoVC_txtBirthday_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_txtBirthday_plaTitle"];
    // 请选择
    NSString *improveInfoVC_txtAddress_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_txtAddress_plaTitle"];
    // 提交信息，立获优惠
    NSString *improveInfoVC_btnCommit_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"improveInfoVC_btnCommit_title"];
    
    self.label1.text = improveInfoVC_label1_title;
    self.label2.text = improveInfoVC_label2_title;
    self.label3.text = improveInfoVC_label3_title;
    self.label4.text = improveInfoVC_label4_title;
    self.label5.text = improveInfoVC_label5_title;
    self.sexLabel.text = improveInfoVC_sexLabel_title;
    self.jobLabel.text = improveInfoVC_jobLabel_title;
    
    self.txtBirthday.placeholder = improveInfoVC_txtBirthday_plaTitle;
    self.txtAddress.placeholder = improveInfoVC_txtAddress_plaTitle;
    [self.btnCommit setTitle:improveInfoVC_btnCommit_title forState:(UIControlStateNormal)];

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
