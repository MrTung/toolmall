//
//  UserSignInResponse.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "SIGNIN_DATA.h"
#import "Status.h"

@interface UserSignInResponse : BaseModel
@property SIGNIN_DATA * data;
@property Status * status;

+ (UserSignInResponse *) parseFromNSDictionary: (NSDictionary *) dic;
- (void)convert:(NSDictionary*)dataSource;
@end
