//
//  AppGiftItem.h
//  eshop
//
//  Created by mc on 16/6/27.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppProduct.h"
#import "CartItemAccessory.h"
@interface AppGiftItem : BaseModel

/** 数量 */
@property int quantity;

/** 赠品 */
@property AppProduct *gift;
@property NSString *name;


@property CartItemAccessory *accessory;

@end
