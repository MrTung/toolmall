//
//  Favorite.h
//  eshop
//
//  Created by mc on 16/3/31.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface Favorite : BaseModel

@property NSString * image;
@property NSString * name;
@property NSNumber * price;
@property int productId;
@property BOOL isSelected;

@end
