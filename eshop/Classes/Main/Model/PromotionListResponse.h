//
//  PromotionListResponse.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppPromotion.h"
@interface PromotionListResponse : BaseModel
@property Status *status;
@property NSMutableArray *data;

+ (Class)data_class;
@end
