//
//  AppCart.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "BaseModel.h"
#import "AppCartItem.h"

@interface AppCart : BaseModel

@property(nonatomic,strong) NSNumber* selectedTotal;
@property(nonatomic,assign)int cartId;
@property(nonatomic,copy) NSString* cartToken;
@property(nonatomic,strong) NSArray*  cartItems;

+ (Class) cartItems_class;
- (int) getQuantities;

@end
