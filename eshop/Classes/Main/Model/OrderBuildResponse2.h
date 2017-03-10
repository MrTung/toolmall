

#import "BaseModel.h"
#import "AppPaymentMethod.h"
#import "AppOrderInfo.h"
#import "Address.h"
@interface OrderBuildResponse2 : BaseModel

@property (nonatomic) Status * status;
@property (nonatomic) NSMutableArray * orders;
@property (nonatomic) NSNumber * balanceAmt;
@property (nonatomic) NSMutableArray * paymentMethods;
@property (nonatomic) int totalPoint;
@property (nonatomic) Address *defaultAddress;

+ (Class) orders_class;
+ (Class) paymentMethods_class;

- (NSNumber*) getTotalAmount;
@end
