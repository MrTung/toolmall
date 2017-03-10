//
//  CountMemberService.h
//  eshop
//
//  Created by mc on 16/3/14.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "CountMemberRequest.h"

@interface CountMemberService : BaseService

- (void) increaseActive:(CountMemberRequest *) request;
- (void) heatBeatRequest:(NSString *) imei;


@end
