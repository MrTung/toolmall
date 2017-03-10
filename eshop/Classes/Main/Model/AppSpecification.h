//
//  AppSpecification.h
//  eshop
//
//  Created by mc on 16/3/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSpecificationValue.h"
@interface AppSpecification : BaseModel
@property NSString *name;
@property NSArray *specificationValues;
+ (Class)specificationValues_class;
@end
