//
//  AppPaymentMethod.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppPaymentMethod : BaseModel

@property int id;

/** 名称 */
@property NSString* name;

/** 方式 */
@property NSString* method;


@end
