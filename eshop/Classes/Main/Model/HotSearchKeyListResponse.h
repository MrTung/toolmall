//
//  HotSearchKeyListResponse.h
//  eshop
//
//  Created by mc on 16/3/8.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSearchKeyListResponse : BaseModel

@property Status * status;
@property NSArray * data;
@property NSArray * searchHistories;
@property Paginated * paginated;

@end
