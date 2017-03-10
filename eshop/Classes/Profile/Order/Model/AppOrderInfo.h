//
//  AppOrderInfo.h
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "BaseModel.h"
#import "AppShippingMethod.h"
#import "AppCouponCode.h"
#import "AppShippingMethod.h"
#import "AppPaymentMethod.h"
#import "AppOrderItem.h"
#import "AppDeposit.h"
#import "AppExpressInfo.h"

@interface AppOrderInfo : BaseModel
@property long id;

/** 订单编号 */
@property(nonatomic,copy) NSString * sn;
@property(nonatomic,assign) int merchantId; //卖家ID
@property(nonatomic,copy) NSString* merchantName; //卖家名称
@property(nonatomic,copy) NSString* shopName; //店名
/** 订单状态 */
@property(nonatomic,copy) NSString * orderStatus;
@property(nonatomic,copy) NSString * orderStatusName;
/** 支付状态 */
@property(nonatomic,copy) NSString* paymentStatus;
/** 配送状态 */
@property(nonatomic,copy) NSString* shippingStatus;
/** 支付手续费 */
@property(nonatomic,strong) NSNumber *fee;
/** 运费 */
@property(nonatomic,strong) NSNumber *freight;
/** 促销折扣 */
@property(nonatomic,strong) NSNumber * promotionDiscount;
/** 优惠券折扣 */
@property(nonatomic,strong) NSNumber * couponDiscount;
/** 调整金额 */
@property(nonatomic,strong) NSNumber * offsetAmount;
/** 已付金额 */
@property(nonatomic,strong) NSNumber * amountPaid;
/** 赠送积分 */
@property(nonatomic,assign) long point;
/** 收货人 */
@property(nonatomic,copy) NSString * consignee;
@property(nonatomic,assign) long areaId; //地区编号
/** 地区名称 */
@property(nonatomic,copy) NSString * areaName;
@property(nonatomic,assign) long receiverId;
/** 地址 */
@property(nonatomic,copy) NSString * address;
/** 邮编 */
@property(nonatomic,copy) NSString * zipCode;
/** 电话 */
@property(nonatomic,copy) NSString * phone;
/** 是否开据发票 */
@property Boolean isInvoice;
/** 发票抬头 */
@property(nonatomic,copy) NSString * invoiceTitle;

/** 税金 */
@property(nonatomic,strong) NSNumber * tax;
@property(nonatomic,copy) NSString* invoiceType;
@property(nonatomic,copy) NSString * invoiceCompanyName;
@property(nonatomic,copy) NSString * invoiceCompanyAddress;
@property(nonatomic,copy) NSString * invoiceCompanyPhone;
@property(nonatomic,copy) NSString * invoiceBankName;
@property(nonatomic,copy) NSString * invoiceBankAccountNo;
@property(nonatomic,copy) NSString* cancelReason;

/** 取消日期 **/
@property(nonatomic,strong) NSDate * cancelDate;
/** 是否已确认收货 **/
@property Boolean isConfirmReceive;
/** 确认收货日期**/
@property(nonatomic,strong) NSDate *confirmReceiveDate;
/** 是否逻辑删除 **/
@property Boolean isLogicDelete;
/** 逻辑删除日期**/
@property(nonatomic,strong) NSDate * logicDeleteDate;
/** 附言 */
@property(nonatomic,copy) NSString * memo;
/** 促销 */
@property(nonatomic,copy) NSString * promotion;
/** 到期时间 */
@property(nonatomic,strong) NSDate * expire;
/** 锁定到期时间 */
@property(nonatomic,strong) NSDate * lockExpire;
/** 是否已分配库存 */
@property Boolean isAllocatedStock;
/** 支付方式名称 */
@property(nonatomic,copy) NSString * paymentMethodName;
/** 配送方式名称 */
@property(nonatomic,copy) NSString * shippingMethodName;
@property(nonatomic,strong) NSDate * createDate;
/** 支付方式 */
@property AppPaymentMethod* paymentMethod;
/** 配送方式 */
@property AppShippingMethod* shippingMethod;
/** 优惠码 */
@property AppCouponCode* couponCode;
/** 订单项 */
@property(nonatomic,copy) NSMutableArray* appOrderItems;
@property(nonatomic,copy) NSMutableArray* deposits;
@property(nonatomic,assign) int weight;
/**
 * 获取商品数量
 *
 * @return 商品数量
 */
@property int quantity;
/**
 * 获取已发货数量
 *
 * @return 已发货数量
 */
@property int  shippedQuantity;
/**
 * 获取已退货数量
 *
 * @return 已退货数量
 */
@property int returnQuantity;
@property AppExpressDtl *lastExpressInfo; //最后一条物流信息
@property NSNumber * finalPrice; //折扣后商品总金额
@property NSNumber * price;
@property NSNumber * amount;
@property NSNumber * amountPayable;
@property Boolean isExpired;
@property Boolean payEnable;
@property Boolean cancelEnable;
@property Boolean confirmReceiveEnable;
@property Boolean expressViewEnable;
@property Boolean reviewEnable;
@property Boolean remindShippingEnable;
@property Boolean myReviewsEnable;
@property NSMutableArray* validCouponCodes;
@property NSMutableArray* shippingMethods;
@property AppCouponCode *mostFavorableCouponCode;

+ (Class)appOrderItems_class;
+ (Class)deposits_class;
+ (Class)validCouponCodes_class;
+ (Class)shippingMethods_class;


/** 订单失效时间 */
@property NSString * orderValidMsg;


@end
