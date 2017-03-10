//
//  BrandService.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"

#import "MoreBrandsCatalistResponse.h"
#import "MoreBrandsResponse.h"
#import "BrandsDetailCatalistResponse.h"
#import "BrandsDetailProductsResponse.h"

@interface BrandService : BaseService

/** 品牌推荐首页一级分类列表 **/
- (void)getMoreBrandsCatalist;

/** 品牌推荐首页一级分类品牌图标 **/
- (void)getBrandDetailById:(int)brandId;

/** 品牌推荐 单个品牌简介 分类列表 **/
- (void)getBrandDetailCatalistById:(int)brandId;

/** 品牌推荐 单个品牌 分类商品列表 **/
- (void)getBrandDetailCatalistById:(int)brandId cataId:(int)cataId pagination:(Pagination *)pagination;

@end
