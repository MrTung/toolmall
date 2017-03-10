//
//  BrandsDetailCatalistResponse.h
//  eshop
//
//  Created by gs_sh on 17/2/14.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface BrandsDetailCatalistResponse : BaseModel

@property Status *status;
@property (nonatomic, retain) AppBrand *appBrand;

@property (nonatomic, retain) NSMutableArray *appProductCategories;

+ (Class)appProductCategories_class;

@end
