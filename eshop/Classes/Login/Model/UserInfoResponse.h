//
//  UserInfoResponse.h
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "BaseModel.h"

@interface UserInfoResponse : BaseModel
@property Status * status;
@property USER * data;
@end
