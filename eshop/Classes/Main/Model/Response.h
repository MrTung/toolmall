//
//  Response.h
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppActivity.h"
@interface Response : BaseModel

@property Status * status;
@property AppActivity * data;


@end
