//
//  OrderInvoice.m
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderInvoice.h"

//#import "Masonry.h"
//#import "IQKeyboardManager.h"
//#import "IQKeyboardReturnKeyHandler.h"
//#import "IQUIView+IQKeyboardToolbar.h"
@interface OrderInvoice ()

@property (weak, nonatomic) IBOutlet UILabel *regLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel1;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel2;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel3;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel4;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel5;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel6;

@end

@implementation OrderInvoice

- (void)viewDidLoad {
    [super viewDidLoad];
    layoutInited = false;
    [self addNavBackButton];
    // Do any additional setup after loading the view from its nib.
    [_btnVatTax setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    [_btnVatTax setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
    [_btnRegTax setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    [_btnRegTax setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
    [_btnNoTax setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
    [_btnNoTax setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];

    // @"发票信息"
    NSString *orderInvoice_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_navItem_title"];
    self.navigationItem.title = orderInvoice_navItem_title;
    NSString *invoiceType = nil;
    if (initInvoice.invoiceType == nil ) {
        invoiceType = nil;
    }
    else if ([initInvoice.invoiceType isEqualToString:@"REG"]){
        _tf_title.text = initInvoice.invoiceTitle;
        invoiceType = @"REG";
    } else {
        _tf_bankAccount.text = initInvoice.invoiceBankName;
        _tf_bankName.text = initInvoice.invoiceBankName;
        _tf_companyAddres.text = initInvoice.invoiceCompanyAddress;
        _tf_companyName.text = initInvoice.invoiceCompanyName;
        _tf_companyPhone.text = initInvoice.invoiceCompanyPhone;
        _tf_InvoiceNo.text = initInvoice.invoiceTaxNo;
        invoiceType = @"VAT";
    }
    [self displayInvoice:invoiceType];
    [self addSubmitButton:invoiceType];
    
    [self refreshUI];
    [self setTextValue];
}

- (void)refreshUI {
    
    // @"发票抬头:"
    NSString *orderInvoice_leftMargin_size = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_leftMargin_size"];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.tf_title.font forKey:NSFontAttributeName];
    CGSize size = [orderInvoice_leftMargin_size sizeWithAttributes:dic];
    CGFloat leftMargin = size.width;
    
    CGFloat txtWidth = TMScreenW - TMScreenW *10/320 - leftMargin - 16;
    NSArray *txtFields = [[NSArray alloc] initWithObjects:self.tf_bankAccount, self.tf_bankName, self.tf_companyAddres, self.tf_companyName, self.tf_companyPhone, self.tf_title, self.tf_InvoiceNo, nil];
    for (UITextField *txtField in txtFields){
        CGRect txtFrame = CGRectMake(TMScreenW *5/320 + leftMargin + 8, txtField.frame.origin.y, txtWidth, txtField.frame.size.height);
        txtField.frame = txtFrame;
    }
    
    self.vatInvoiceDesc.frame = CGRectMake(self.vatInvoiceDesc.frame.origin.x, self.vatInvoiceDesc.frame.origin.y, txtWidth + leftMargin, TMScreenH *121/568);
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(TMScreenH *0/568);
        make.left.equalTo(self.view.mas_left).offset(TMScreenW *5/320);
        make.right.equalTo(self.view.mas_right).offset(-TMScreenW *5/320);
        make.height.mas_equalTo(43);
    }];
    [self.regTaxView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom).offset(TMScreenH *0/568);
        make.left.equalTo(self.view.mas_left).offset(TMScreenW *5/320);
        make.right.equalTo(self.view.mas_right).offset(-TMScreenW *5/320);
        make.height.mas_equalTo(36);
    }];
    [self.vatTaxView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom).offset(TMScreenH *0/568);
        make.left.equalTo(self.view.mas_left).offset(TMScreenW *5/320);
        make.right.equalTo(self.view.mas_right).offset(-TMScreenW *5/320);
        make.height.mas_equalTo(TMScreenH *557/736);
    }];

}

- (void)addSubmitButton:(NSString*)invoiceType{
    if ([invoiceType isEqualToString:@"VAT"]){
        self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(TMScreenW *8/320, TMScreenH *430/568, [[UIScreen mainScreen] applicationFrame].size.width - TMScreenW *16/320  , TMScreenH *30/568)];
    } else {
        self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(TMScreenW *8/320, TMScreenH *110/568, [[UIScreen mainScreen] applicationFrame].size.width - TMScreenW *16/320  , TMScreenH *30/568)];
    }
    
    // @"提交"
    NSString *orderInvoice_btnSubmit_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_btnSubmit_title"];
    [self.btnSubmit setTitle:orderInvoice_btnSubmit_title forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_btn.png" ] forState:UIControlStateNormal];
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (void)setInvoice:(AppInvoice *)invoice{
    initInvoice = invoice;
    [self displayInvoice:invoice.invoiceType];
}

- (void)displayInvoice:(NSString*)invoiceType{
    if (invoiceType == nil) {
        _btnRegTax.selected = false;
        _btnVatTax.selected = false;
        _regTaxView.hidden = YES;
        _vatTaxView.hidden = YES;
        _btnNoTax.selected = YES;
        
        _btnSubmit.center= CGPointMake(self.view.frame.size.width / 2, TMScreenH *110/568);
    }
   else if ([invoiceType isEqualToString:@"REG"]){
        _btnRegTax.selected = true;
        _btnVatTax.selected = false;
        _regTaxView.hidden = NO;
        _vatTaxView.hidden = YES;
        _btnNoTax.selected = NO;
        _btnSubmit.center= CGPointMake(self.view.frame.size.width / 2, TMScreenH *110/568);
    } else {
        _btnRegTax.selected = false;
        _btnVatTax.selected = true;
        _regTaxView.hidden = YES;
        _vatTaxView.hidden = NO;
        _btnNoTax.selected = NO;
        _btnSubmit.center= CGPointMake(self.view.frame.size.width / 2, TMScreenH *430/568);
    }

}

- (IBAction)clickInvoiceType:(UIButton*)sender{
    if (sender.tag == 1 && !_btnRegTax.selected){
        _btnRegTax.selected = true;
        _btnVatTax.selected = false;
        _btnNoTax.selected = false;
        [self displayInvoice:@"REG"];
    } else if (sender.tag == 2 && !_btnVatTax.selected){
        _btnRegTax.selected = false;
        _btnVatTax.selected = true;
        _btnNoTax.selected = false;
        [self displayInvoice:@"VAT"];
    }else if(sender.tag == 3 && !_btnNoTax.selected){
        _btnRegTax.selected = false;
        _btnVatTax.selected = false;
        _btnNoTax.selected = true;
        [self displayInvoice:nil];

    }
}

- (IBAction)clickSubmit:(UIButton*)sender{
    
    // @"请输入发票抬头"
    NSString *orderInvoice_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg1"];
    // @"请输入单位名称"
    NSString *orderInvoice_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg2"];
    // @"请输入单位地址"
    NSString *orderInvoice_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg3"];
    // @"请输入单位电话"
    NSString *orderInvoice_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg4"];
    // @"请输入开户行"
    NSString *orderInvoice_toastNotification_msg5 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg5"];
    // @"请输入银行帐号"
    NSString *orderInvoice_toastNotification_msg6 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg6"];
    // @"请输入税号"
    NSString *orderInvoice_toastNotification_msg7 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_toastNotification_msg7"];
    
    AppInvoice *invoice = [[AppInvoice alloc] init];
    if (_btnNoTax.selected) {
        invoice.invoiceType = nil;
    }
   else  if (_btnRegTax.selected){
        if ([CommonUtils trim:_tf_title.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        invoice.invoiceType = @"REG";
        invoice.invoiceTitle = [CommonUtils trim:_tf_title.text];
    } else {
        if ([CommonUtils trim:_tf_companyName.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        if ([CommonUtils trim:_tf_companyAddres.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        if ([CommonUtils trim:_tf_companyPhone.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        if ([CommonUtils trim:_tf_bankName.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg5 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        if ([CommonUtils trim:_tf_bankAccount.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg6 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        if ([CommonUtils trim:_tf_InvoiceNo.text].length == 0){
            [CommonUtils ToastNotification:orderInvoice_toastNotification_msg7 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        invoice.invoiceType = @"VAT";
        invoice.invoiceCompanyName = [CommonUtils trim:_tf_companyName.text];
        invoice.invoiceCompanyAddress = [CommonUtils trim:_tf_companyAddres.text];
        invoice.invoiceCompanyPhone = [CommonUtils trim:_tf_companyPhone.text];
        invoice.invoiceBankName = [CommonUtils trim:_tf_bankName.text];
        invoice.invoiceBankAccountNo = [CommonUtils trim:_tf_bankAccount.text];
        invoice.invoiceTaxNo = [CommonUtils trim:_tf_InvoiceNo.text];
    }
    
    NSArray *controllers = [self.navigationController viewControllers];
    OrderController *orderController = (OrderController*)[controllers objectAtIndex:controllers.count - 2];
    [orderController setInvoice:invoice];
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSInteger tag = textField.tag;
    if (tag == 15){
        //[self clickSubmit:self.btnSubmit];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    } else {
        UITextField *nextField = [self.view viewWithTag:tag + 1];
        [nextField becomeFirstResponder];
    }
    return YES;
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 普通发票
    NSString *orderInvoice_btnRegTaxWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_btnRegTaxWord_title"];
    // 增值税发票
    NSString *orderInvoice_btnVatTaxWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_btnVatTaxWord_title"];
    // 不需要
    NSString *orderInvoice_btnNoTaxWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_btnNoTaxWord_title"];
    // 发票抬头:
    NSString *orderInvoice_regTaxView_label = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_regTaxView_label"];
    // 单位名称:
    NSString *orderInvoice_vatTaxView_label1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label1"];
    // 单位地址:
    NSString *orderInvoice_vatTaxView_label2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label2"];
    // 单位电话:
    NSString *orderInvoice_vatTaxView_label3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label3"];
    // 开  户  行:
    NSString *orderInvoice_vatTaxView_label4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label4"];
    // 银行帐号:
    NSString *orderInvoice_vatTaxView_label5 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label5"];
    // 税        号:
    NSString *orderInvoice_vatTaxView_label6 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatTaxView_label6"];
    //   需开具增值税专用发票的顾客，需要提供以下材料并加盖公章之后，扫描发送到土猫网邮箱中： ①营业执照副本，②税务登记证副本复印件，③一般纳税人资格证书， ④银行开户许可证，⑤组织机构代码证。 土猫邮箱：toolmall@greatstartools.com，工作人员审核后将为您开具增值税发票。
    NSString *orderInvoice_vatInvoiceDesc_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInvoice_vatInvoiceDesc_title"];
    
    [self.btnRegTaxWord setTitle:orderInvoice_btnRegTaxWord_title forState:(UIControlStateNormal)];
    [self.btnVatTaxWord setTitle:orderInvoice_btnVatTaxWord_title forState:(UIControlStateNormal)];
    [self.btnNoTaxWord setTitle:orderInvoice_btnNoTaxWord_title forState:(UIControlStateNormal)];
    self.regLabel.text = orderInvoice_regTaxView_label;
    self.vatLabel1.text = orderInvoice_vatTaxView_label1;
    self.vatLabel2.text = orderInvoice_vatTaxView_label2;
    self.vatLabel3.text = orderInvoice_vatTaxView_label3;
    self.vatLabel4.text = orderInvoice_vatTaxView_label4;
    self.vatLabel5.text = orderInvoice_vatTaxView_label5;
    self.vatLabel6.text = orderInvoice_vatTaxView_label6;
    self.vatInvoiceDesc.text = orderInvoice_vatInvoiceDesc_title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if(textField == self.txtNumberType){
//        self.isStatusBarHidden = YES;
//        [UIView animateWithDuration:0.25 animations:^{
//            [self setNeedsStatusBarAppearanceUpdate];
//        }];
//    }
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField == self.txtNumberType){
//        self.isStatusBarHidden = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            [self setNeedsStatusBarAppearanceUpdate];
//        }];
//    }
//}
//
//-(BOOL)prefersStatusBarHidden{
//    return self.isStatusBarHidden;
//}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
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
