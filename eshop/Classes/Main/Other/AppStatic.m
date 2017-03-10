//
//  AppStatic.m
//  eshop
//
//  Created by mc on 15/11/3.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AppStatic.h"
static int cartItemQuantities = 0;
static UITabBarItem *CartTabBarItem;
@implementation AppStatic

+ (int)CART_ITEM_QUANTITIES{
    return cartItemQuantities; 
}

+ (void)setCART_ITEM_QUANTITIES:(int)quantities{
    cartItemQuantities = quantities;

    if ([AppStatic CART_ITEM_QUANTITIES]) {
        
        if([AppStatic CART_ITEM_QUANTITIES] < 1000){
            [AppStatic CART_ITEM_BAR_ITEM].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES] ];
        }else{
          [AppStatic CART_ITEM_BAR_ITEM].badgeValue = @"…";
        }
        
    } else {
        [AppStatic CART_ITEM_BAR_ITEM].badgeValue = nil;
    }
}

+ (UITabBarItem*)CART_ITEM_BAR_ITEM{
    return CartTabBarItem;
}

+ (void)setCART_ITEM_BAR_ITEM:(UITabBarItem*)tabbarItem{
    CartTabBarItem = tabbarItem;
}


@end
