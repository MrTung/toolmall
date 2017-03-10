//
//  AppActivity.h
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppActivity : BaseModel

@property long id;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * introduction;
@property(nonatomic,copy) NSString * bannerImage;
@property(nonatomic,strong) NSDate * beginDate;
@property(nonatomic,strong) NSDate * endDate;
@property(nonatomic,copy) NSString * type;


@end
