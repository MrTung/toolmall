//
//  MyCordovaPlugin.m
//  study
//
//  Created by mc on 15-10-30.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "MyCordovaPlugin.h"

@implementation MyCordovaPlugin



- (void)execute:(CDVInvokedUrlCommand*)command
{
    NSString* value0 = [NSString stringWithFormat:@"%@(%@)", [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"] ,[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value0];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


- (void)openProductDetail:(CDVInvokedUrlCommand*)command{
    NSString *strProductId = [command.arguments objectAtIndex:0];
    int productId = [strProductId intValue];
//    ProdInfo *prodInfo = [[ProdInfo alloc] init];
    ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] init];
    
    prodInfo.productId = productId;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.viewController.navigationItem.backBarButtonItem = barButtonItem;
    [self.viewController.navigationController pushViewController:prodInfo animated:YES];
}

- (void)openLink:(CDVInvokedUrlCommand*)command{
    @try {
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.viewController.navigationItem.backBarButtonItem = barButtonItem;
        
        NSString *url = [command.arguments objectAtIndex:0];
        if ([url isEqual:@"morePromotion"]){
            PromotionList *promotionList = [[PromotionList alloc] initWithNibName:@"PromotionList" bundle:nil];
            [self.viewController.navigationController pushViewController:promotionList animated:YES];

        } else if ([url isEqual:@"moreBrand"] || [url rangeOfString:@"brand/list/\\d\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            MoreBrands *moreBrands = [[MoreBrands alloc] initWithNibName:@"MoreBrands" bundle:nil];
            [self.viewController.navigationController pushViewController:moreBrands animated:YES];
        } else if ([url isEqual:@"moreHotProducts"]){
            
            ProdList *prodList = [[ProdList alloc] init];
            prodList.tagId = 1;
            [self.viewController.navigationController pushViewController:prodList animated:YES];
        } else if ([url rangeOfString:@"/product/list/\\d+\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strProdCat = [array objectAtIndex:array.count - 1];
            strProdCat = [strProdCat stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int prodCatId = [strProdCat intValue];
            ProdList *prodList = [[ProdList alloc] init];
            prodList.productCategoryId = prodCatId;
//            MoreBrands *moreBrands = [[MoreBrands alloc] initWithNibName:@"MoreBrands" bundle:nil];
            [self.viewController.navigationController pushViewController:prodList animated:YES];
        } else if ([url rangeOfString:@"/product/content/\\d+/\\d+\\.html" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strProdId = [array objectAtIndex:array.count - 1];
            strProdId = [strProdId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int prodId = [strProdId intValue];
            ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] init];
            prodInfo.productId = prodId;
            [self.viewController.navigationController pushViewController:prodInfo animated:YES];
        } else if ([url rangeOfString:@"/product/content/\\d+\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strProdId = [array objectAtIndex:array.count - 1];
            strProdId = [strProdId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int prodId = [strProdId intValue];
            ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] init];
            prodInfo.productId = prodId;
            [self.viewController.navigationController pushViewController:prodInfo animated:YES];
        } else if ([url rangeOfString:@"/productinfo/\\d+\\.html" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strProdId = [array objectAtIndex:array.count - 1];
            strProdId = [strProdId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int prodId = [strProdId intValue];
            ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] init];
            prodInfo.productId = prodId;
            [self.viewController.navigationController pushViewController:prodInfo animated:YES];
        } else if ([url rangeOfString:@"/promotion/productlist/\\d+\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strPromId = [array objectAtIndex:array.count - 1];
            strPromId = [strPromId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int prmoId = [strPromId intValue];
            ProdList *prodList = [[ProdList alloc] init];
            prodList.promotionId = prmoId;
            [self.viewController.navigationController pushViewController:prodList animated:YES];
        } else if ([url rangeOfString:@"/activity/productlist/\\d+\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strActivityId = [array objectAtIndex:array.count - 1];
            strActivityId = [strActivityId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int activityId = [strActivityId intValue];
            ProdList *prodList = [[ProdList alloc] init];
            prodList.activityId = activityId;
            [self.viewController.navigationController pushViewController:prodList animated:YES];
        } else if ([url rangeOfString:@"/brand/productlist/\\d+\\.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString *strBrandId = [array objectAtIndex:array.count - 1];
            strBrandId = [strBrandId stringByReplacingOccurrencesOfString:@".jhtm" withString:@""];
            int brandId = [strBrandId intValue];
            ProdList *prodList = [[ProdList alloc] init];
            prodList.brandId = brandId;
            [self.viewController.navigationController pushViewController:prodList animated:YES];
        } else if ([url rangeOfString:@"/register.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            RegisteViewController *registerViewController = [[RegisteViewController alloc] init];
            [self.viewController.navigationController pushViewController:registerViewController animated:YES];
        } else if ([url rangeOfString:@"/member/favorite/list.jhtm" options:NSRegularExpressionSearch].location != NSNotFound){
            if ([CommonUtils chkLogin:self.viewController gotoLoginScreen:YES]){
                FavoriteListController *favoriteListController = [[FavoriteListController alloc] init];
                [self.viewController.navigationController pushViewController:favoriteListController animated:YES];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (void)openLogin:(CDVInvokedUrlCommand*)command{
    
    ShopLoginViewController *loginVC = [[ShopLoginViewController alloc] initWithNibName:@"ShopLoginViewController" bundle:nil];
    [self.viewController.navigationController pushViewController:loginVC animated:YES];
}
@end
