//
//  PromotionService.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "PromotionListResponse.h"

@interface PromotionService : BaseService


- (void) getPromotionList:(NSString*) promotionType pagination:(Pagination*) pagination;
@end
