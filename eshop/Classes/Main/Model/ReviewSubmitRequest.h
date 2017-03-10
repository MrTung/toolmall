//
//  ReviewSubmitRequest.h
//  eshop
//
//  Created by mc on 15/11/6.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface ReviewSubmitRequest : BaseModel
@property SESSION *session;
@property NSMutableArray *reviews;
@end
