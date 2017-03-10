//
//  FavoriteListResponse.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "FavoriteList.h"
#import "Paginated.h"
@interface FavoriteListResponse : BaseModel
@property Status *status;
@property NSMutableArray *data;
@property Paginated *paginated;

+ (Class) data_class;
@end
