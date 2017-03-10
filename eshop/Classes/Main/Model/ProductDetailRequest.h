//
//  ProductDetailRequest.h
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "BaseService.h"

@interface ProductDetailRequest : BaseModel
@property (nonatomic) NSInteger productId;
@property (nonatomic,strong) SESSION *session;
@end
