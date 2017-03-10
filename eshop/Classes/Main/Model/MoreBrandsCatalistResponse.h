//
//  MoreBrandsCatalistResponse.h
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface MoreBrandsCatalistResponse : BaseModel

@property Status *status;

@property (nonatomic, retain) NSMutableArray *data;

+ (Class)data_class;

@end
