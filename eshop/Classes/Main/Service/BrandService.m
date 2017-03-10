//
//  BrandService.m
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BrandService.h"

@implementation BrandService

- (void)getMoreBrandsCatalist {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"1" value:@"1"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    MoreBrandsCatalistResponse *respObj = [[MoreBrandsCatalistResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_more_brandsCatalist];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_more_brandsCatalist params:params responseObj:respObj];
}

- (void)getBrandDetailById:(int)brandId {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"cataId" value:brandId];
    [CommonUtils fillStrToDictionary:params key:@"1" value:@"1"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    MoreBrandsResponse *respObj = [[MoreBrandsResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_more_brandDetail];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_more_brandDetail params:params responseObj:respObj];
}

- (void)getBrandDetailCatalistById:(int)brandId {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"brandId" value:brandId];
    [CommonUtils fillStrToDictionary:params key:@"1" value:@"1"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    BrandsDetailCatalistResponse *respObj = [[BrandsDetailCatalistResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_more_brandsecondCatatList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_more_brandsecondCatatList params:params responseObj:respObj];
}

- (void)getBrandDetailCatalistById:(int)brandId cataId:(int)cataId pagination:(Pagination *)pagination {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"brandId" value:brandId];
    [CommonUtils fillIntToDictionary:params key:@"cataId" value:cataId];
    [CommonUtils fillStrToDictionary:params key:@"1" value:@"1"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    [params setObject:[pagination toJsonString] forKeyedSubscript:@"pagination"];
    
    BrandsDetailProductsResponse *respObj = [[BrandsDetailProductsResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_more_brandsecondCatatProductList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_more_brandsecondCatatProductList params:params responseObj:respObj];
}

@end
