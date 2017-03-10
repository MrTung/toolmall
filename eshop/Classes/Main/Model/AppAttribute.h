//
//  AppAttribute.h
//  eshop
//
//  Created by mc on 15/11/16.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppAttribute : BaseModel
@property(nonatomic,assign) int id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) int propertyIndex;
@property(nonatomic,copy) NSMutableArray *options;

+ (Class)options_class;
@end
