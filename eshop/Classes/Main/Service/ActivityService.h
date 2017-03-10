//
//  ActivityService.h
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "Response.h"
#import "ListResponse.h"

@interface ActivityService : BaseService


//获取活动信息
- (void)getActivityInfoWithId:(long)activityId;


//获取活动产品列表
- (void)getActivityListWithId:(long)activityId pagination:(Pagination *)pagination;

@end
