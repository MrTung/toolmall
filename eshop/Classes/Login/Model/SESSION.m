//
//  SESSION.m
//  toolmall
//
//  Created by mc on 15/10/14.
//
//
static SESSION * session;
static NSString *mobileNo;
static Boolean isUserNameChanged;
#import "SESSION.h"

@implementation SESSION
@synthesize uid;
@synthesize sid;
@synthesize key;
@synthesize cartId;
@synthesize cartToken;

+ (SESSION *) getSession{
    if (session == nil){
        session = [SESSION alloc];
        NSString * uid = [[Config Instance] getUserInfo:@"uid"];
        if (uid == nil){
            session.uid = -1;
        } else {
            session.uid = [uid intValue];
        }
        session.sid = [[Config Instance] getUserInfo:@"sid"];
        session.uname = [[Config Instance] getUserInfo:@"uname"];
        session.key = [[Config Instance] getUserInfo:@"key"];
        NSString * cartId = [[Config Instance] getUserInfo:@"cartId"];
        if (cartId == nil){
            session.cartId = -1;
        } else {
            session.cartId = [cartId intValue];
        }
        session.cartToken = [[Config Instance] getUserInfo:@"cartToken"];
        session.sessionId = [[UIDevice currentDevice] uniqueAppInstanceIdentifier];
    }
//    NSLog(@"%@", [NSString stringWithFormat:@"cartId:%d", session.cartId]);
    return session;
}

+ (void) setSession:(SESSION *)sion{
    session = sion;
}

+ (NSString*)getMobileNo{
    return mobileNo;
}

+ (void)setMobileNo: (NSString*)mobile{
    mobileNo = mobile;
}

+ (Boolean)getIsUserNameChanged{
    return isUserNameChanged;
}

+ (void)setIsUserNameChanged: (Boolean)userNameChanged{
    isUserNameChanged = userNameChanged;
}

- (NSString *) getStringUId{
    return [NSString stringWithFormat:@"%d", uid];
}
- (NSString *) getStringCartId{
    return [NSString stringWithFormat:@"%d", cartId];
}

@end
