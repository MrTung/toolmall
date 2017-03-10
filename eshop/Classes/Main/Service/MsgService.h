//
//  MsgService.h
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "MsgListResponse.h"
#import "StatusResponse.h"

@interface MsgService : BaseService


- (void)getMsgList:(Pagination *)pagination;

- (void) viewMsg:(int)msgId;

- (void) reply:(int)msgId content:(NSString*)content;

- (void) send:(NSString*)title  content:(NSString*)content;
@end
