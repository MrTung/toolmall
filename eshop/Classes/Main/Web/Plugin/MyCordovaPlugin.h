//
//  MyCordovaPlugin.h
//  study
//
//  Created by mc on 15-10-30.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "CDVPlugin.h"

//#import "ProdInfo.h"
#import "ProductInfoViewController.h"
//#import "CatProdList.h"
#import "ProdList.h"
#import "MoreBrands.h"
#import "PromotionList.h"
#import "RegisteViewController.h"
#import "FavoriteListController.h"

@interface MyCordovaPlugin : CDVPlugin

- (void)execute:(CDVInvokedUrlCommand*)command;
- (void)openProductDetail:(CDVInvokedUrlCommand*)command;

- (void)openLink:(CDVInvokedUrlCommand*)command;
- (void)openLogin:(CDVInvokedUrlCommand*)command;

@end
