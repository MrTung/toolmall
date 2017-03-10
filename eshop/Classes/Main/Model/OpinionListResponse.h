//
//  OpinionListResponse.h
//  eshop
//
//  Created by mc on 16/4/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppReview.h"

@interface OpinionListResponse : BaseModel

@property NSArray * data;
@property Status * status;

+ (Class)data_class;

@end
