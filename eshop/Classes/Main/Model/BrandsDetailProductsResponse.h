//
//  BrandsDetailProductsResponse.h
//  eshop
//
//  Created by gs_sh on 17/2/15.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface BrandsDetailProductsResponse : BaseModel

@property Status *status;
@property Paginated *paginated;

@property (nonatomic, retain) NSMutableArray *data;

+ (Class)data_class;

@end
