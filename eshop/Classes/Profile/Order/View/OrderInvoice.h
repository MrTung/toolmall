//
//  OrderInvoice.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInvoice.h"
#import "OrderController.h"

@interface OrderInvoice : UIBaseController{
    AppInvoice *initInvoice;
    BOOL layoutInited;
}



@property (nonatomic) IBOutlet UIButton *btnRegTax;
@property (nonatomic) IBOutlet UIButton *btnRegTaxWord;
@property (nonatomic) IBOutlet UIButton *btnVatTax;
@property (nonatomic) IBOutlet UIButton *btnVatTaxWord;
@property (nonatomic) IBOutlet UIButton *btnNoTax;
@property (nonatomic) IBOutlet UIButton *btnNoTaxWord;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIView *regTaxView;
@property (nonatomic) IBOutlet UIView *vatTaxView;

@property (nonatomic) IBOutlet UITextField *tf_title;
@property (nonatomic) IBOutlet UITextField *tf_companyName;
@property (nonatomic) IBOutlet UITextField *tf_companyAddres;
@property (nonatomic) IBOutlet UITextField *tf_companyPhone;
@property (nonatomic) IBOutlet UITextField *tf_bankName;
@property (nonatomic) IBOutlet UITextField *tf_bankAccount;
@property (weak, nonatomic) IBOutlet UITextField *tf_InvoiceNo;

@property (nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic) IBOutlet UILabel *vatInvoiceDesc;

- (void)setInvoice:(AppInvoice*)invoice;

@end
