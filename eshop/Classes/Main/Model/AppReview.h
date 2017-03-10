//
//  AppReview.h
//  eshop
//
//  Created by mc on 15/11/5.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppReview : BaseModel
/** 评分 */
@property int score;

/** 内容 */
@property NSString* content;

/** 是否显示 */
@property Boolean isShow;

@property NSString* memberName;

@property NSDate* createDate;
@property int orderItemId;
@property NSString * productImage; //产品图片
@property NSString * productName; //产品名称
@property NSString * productSpecs; //产品规格
@end
