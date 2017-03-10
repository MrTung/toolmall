//
//  FavoriteDeleteRequest.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface FavoriteDeleteRequest : BaseModel

@property int ProductId;
@property SESSION *session;
@end
