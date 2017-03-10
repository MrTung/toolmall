//
//  AppCart.m
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "AppCart.h"

@implementation AppCart
@synthesize cartItems;
+ (Class) cartItems_class{
    return AppCartItem.class;
}
- (int) getQuantities{
    if (cartItems == nil) return 0;
    int quantities = 0;
    for (int i=0; i<cartItems.count; i++){
        quantities += 1;
    }
    return quantities;
}
@end
