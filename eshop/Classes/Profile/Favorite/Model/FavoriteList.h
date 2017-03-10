//
//  FavoriteList.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface FavoriteList : BaseModel
@property(nonatomic,strong) NSNumber *price;
@property(nonatomic,strong) NSNumber *market_price;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) int productId;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,strong) NSNumber *promotePrice;
@property(nonatomic,getter=isSelected) Boolean selected;
@end
