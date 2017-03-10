//
//  SelProdSpecPlugin.h
//  eshop
//
//  Created by mc on 16/3/10.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CDVPlugin.h"

@interface SelProdSpecPlugin : CDVPlugin
- (void)execute:(CDVInvokedUrlCommand*)command;
- (void)selProdSpecifications:(CDVInvokedUrlCommand*)command;
- (void)addToCart:(CDVInvokedUrlCommand*)command;

+ (id<MsgHandler>)MSG_HANDLER;
+ (void)setMSG_HANDLER:(id<MsgHandler>)handler;

@end
