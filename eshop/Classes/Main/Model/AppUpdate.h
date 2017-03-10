//
//  AppUpdate.h
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppUpdate : BaseModel
@property NSString *versionName;
@property NSString *downloadUrl;
@property NSString *upgradePolicy ;
@property NSString *upgradeMsg;
@property Boolean isLatestVersion;
@end
