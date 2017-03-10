//
//  FeedbackTagsResponse.h
//  eshop
//
//  Created by mc on 15-11-6.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppFeedbackTag.h"

@interface FeedbackTagsResponse : BaseModel

@property Status *status;
@property NSMutableArray *data;
@property Paginated *paginated;
+ (Class)data_class;
@end
