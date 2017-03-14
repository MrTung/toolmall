//
//  VersionService.h
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "AppUpdate.h"

@interface VersionService : BaseService

- (void) getUpgradePolicy:(NSString*) appVersion;

#pragma mark 

- (void)getUpgradePolicy:(NSString*) appVersion success:(void (^)(BaseModel*responseObj))success;

@end
