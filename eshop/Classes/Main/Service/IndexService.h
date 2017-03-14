//
//  IndexService.h
//  eshop
//
//  Created by mc on 16/3/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseService.h"

@interface IndexService : BaseService

- (void)getInfoWithBlock:(void (^)(BaseModel*responseObj))success;

- (void)getXMLString;

@end
