//
//  DepositService.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "DepositListResponse.h"

@interface DepositService : BaseService
- (void) getDepositList:(Pagination *)pagination;
@end
