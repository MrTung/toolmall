

#import "BaseModel.h"

@interface AppInvoice : BaseModel
/** 发票抬头 */
@property NSString* invoiceTitle;

/** 税金 */
@property NSNumber* tax;

@property NSString* invoiceType;

@property NSString* invoiceCompanyName;

@property NSString* invoiceCompanyAddress;

@property NSString* invoiceCompanyPhone;

@property NSString* invoiceBankName;

@property NSString* invoiceBankAccountNo;

@property NSString* invoiceTaxNo;

@end
