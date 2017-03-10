//
//  ReviewService.h
//  eshop
//
//  Created by mc on 15/11/5.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "ReviewsResponse.h"
#import "ReviewSubmitRequest.h"

@interface ReviewService : BaseService

- (void) getReviewList:(int)productId pagination:(Pagination*)pagination;

- (void) submit:(NSMutableArray*)reviews isAnonymity:(Boolean)isAnonymity;
@end
