//
//  SIGNIN_DATA.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SESSION.h"
#import "USER.h"
#import "BaseModel.h"

@interface SIGNIN_DATA : BaseModel
@property(nonatomic,strong) SESSION * session;
@property(nonatomic,strong) USER * user;
@property(nonatomic,getter=isDonateCoupon) Boolean donateCoupon;
@property(nonatomic,copy) NSString *donateUrl;
@property(nonatomic,getter=isShowUrl) Boolean showUrl;

@end
