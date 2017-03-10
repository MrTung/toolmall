//
//  OnlinePayResponse.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface OnlinePayResponse : BaseModel

@property Status *status;
@property NSMutableDictionary *data;
@end
