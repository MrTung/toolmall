//
//  FeedbackSubmitRequest.h
//  eshop
//
//  Created by mc on 15-11-6.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface FeedbackSubmitRequest : BaseModel

@property SESSION *session;
@property NSString *content;
@property NSString *channel;
@property NSMutableArray *tags;
@end
