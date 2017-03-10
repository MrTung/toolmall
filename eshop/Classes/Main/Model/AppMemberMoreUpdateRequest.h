//
//  AppMemberMoreUpdateRequest.h
//  eshop
//
//  Created by mc on 16/4/26.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppMemberMoreUpdateRequest : BaseModel
@property NSString *userName;
@property NSString *gender;
@property NSString *birthday;
@property int areaId;
@property NSString *address;
@property NSString *occupation;
@property SESSION *session;
@end
