//
//  MoreBrandsResponse.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

//#import "AppProduct.h"
#import "AppBrand.h"

@interface MoreBrandsResponse : BaseModel

@property Status *status;

//@property AppBrand *weeklyBrand;

@property (nonatomic, retain) NSMutableArray *data;

+ (Class)data_class;

//@property NSMutableArray *weeklyBarndProducts;
//
//@property NSMutableArray *otherBrands;
//
//+ (Class)weeklyBarndProducts_class;
//+ (Class)otherBrands_class;

@end
