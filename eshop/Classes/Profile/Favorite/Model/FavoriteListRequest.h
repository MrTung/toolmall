//
//  FavotiteListRequest.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Pagination.h"
@interface FavoriteListRequest : BaseModel

@property SESSION *session;
@property Pagination *pagination;
@end
