//
//  ProductViewHistoryResponse.h
//  eshop
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppProduct.h"
#import "Paginated.h"
@interface ProductViewHistoryResponse : BaseModel

@property NSArray * data;
@property Status * status;
@property Paginated * paginated;
+ (Class)data_class;

@end
