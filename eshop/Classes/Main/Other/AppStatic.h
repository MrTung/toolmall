//
//  AppStatic.h
//  eshop
//
//  Created by mc on 15/11/3.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppStatic : NSObject

+ (int)CART_ITEM_QUANTITIES;

+ (void)setCART_ITEM_QUANTITIES:(int)quantities;

+ (UITabBarItem*)CART_ITEM_BAR_ITEM;

+ (void)setCART_ITEM_BAR_ITEM:(UITabBarItem*)tabbarItem;


@end
