//
//  CartService.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "BaseService.h"
#import "CartResponse.h"
#import "CartItemRequest.h"
#import "CartItemsRequest.h"
#import "SignalDataResponse.h"
@interface CartService : BaseService

+ (void)setCartResponse:(CartResponse*)cartResp;

- (void) getCartList:(Boolean)showLoading;
- (void) updateCartItem:(int) cartItemId quantity:(int)quantity selected:(Boolean)selected;
- (void) addCartItem:(int) productId quantity:(int)quantity;
- (void) updateMultiplyCartItem:(NSMutableArray*) cartItemIds selected:(Boolean)selected;
- (void) deleteCartItem:(NSMutableArray*) cartItemIds;
//多条商品加入购物车
- (void)addCartItems:(NSArray *)productIds quantities:(NSArray *)quantities;
/** 获取首单免邮信息 */
- (void)getIsFreeInfoOfFirstOrder;
@end
