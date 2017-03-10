//
//  ReviewsResponse.h
//  eshop
//
//  Created by mc on 15/11/5.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppReview.h"
@interface ReviewsResponse : BaseModel

@property Status *status;
@property NSMutableArray *data;
@property Paginated *paginated;

+ (Class)data_class;
@end
