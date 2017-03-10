//
//  CartItemRequest.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "BaseModel.h"

@interface CartItemRequest : BaseModel

@property (nonatomic) int productId;
@property (nonatomic) int quantity;
@property (nonatomic) int cartItemId;
@property (nonatomic) Boolean selected;
@property (nonatomic) SESSION *session;
@end
