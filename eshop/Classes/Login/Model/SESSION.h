//
//  SESSION.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SESSION : BaseModel
@property int uid;
@property(nonatomic,copy) NSString * sid;
@property(nonatomic,copy) NSString * uname;
@property(nonatomic,copy) NSString * key;
@property(nonatomic,assign) int cartId;
@property(nonatomic,copy) NSString * cartToken;
@property(nonatomic,copy) NSString * sessionId;
+ (SESSION *) getSession;
+ (void) setSession:(SESSION *)sion;
+ (NSString*)getMobileNo;
+ (void)setMobileNo: (NSString*)mobile;
+ (Boolean)getIsUserNameChanged;
+ (void)setIsUserNameChanged: (Boolean)userNameChanged;
- (NSString *) getStringUId;
- (NSString *) getStringCartId;

@end
