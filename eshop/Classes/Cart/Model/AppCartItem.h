//
//  AppCartItem.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "BaseModel.h"

#import "AppPromotion.h"
#import "CartItemAccessory.h"
#import "AppGiftItem.h"

@interface AppCartItem : BaseModel

@property(nonatomic,copy) NSString * formatedSubtotal;
@property(nonatomic,assign) int quantity;
@property(nonatomic,strong) NSNumber* subtotal;
@property(nonatomic,assign) int id;
@property(nonatomic,assign) int merchantId;
@property(nonatomic,copy) NSString * merchantName;
@property Boolean selected;
@property(nonatomic,strong) AppProduct* product;
@property(nonatomic,strong) AppPromotion *promotion;
@property(nonatomic,strong) NSNumber *finalPrice;
@property(nonatomic,strong) NSNumber *delPrice;
@property(nonatomic,strong) CartItemAccessory *cartItemAccessory;

/**
 * 购物车中促销的优惠金额
 */
@property(nonatomic,strong) NSNumber *cartDiscountAmount;
@property(nonatomic,strong) NSArray *giftItems;
@property(nonatomic,strong) NSNumber * displayPrice;
@property BOOL isFirst;
@property BOOL isLast;
+ (Class)giftItems_class;

@end
