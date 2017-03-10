//
//  AppBrandCata.h
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppBrandCata : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parentName;

@end
