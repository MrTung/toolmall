//
//  Config.m
//  oschina
//
//  Created by wangjun on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Config.h"
#import "AESCrypt.h"

@implementation Config
@synthesize isLogin;
@synthesize viewBeforeLogin;
@synthesize viewNameBeforeLogin;
@synthesize isNetworkRunning;
@synthesize tweetCachePic;
@synthesize tweet;
@synthesize questionTitle;
@synthesize questionContent;
@synthesize questionIndex;
@synthesize msgs;
@synthesize comments;
@synthesize replies;

-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings setObject:userName forKey:@"UserName"];
    
    pwd = [AESCrypt encrypt:pwd password:@"pwd"];
    
    [settings setObject:pwd forKey:@"Password"];
    [settings synchronize];
}
-(NSString *)getUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UserName"];
}
-(NSString *)getPwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * temp = [settings objectForKey:@"Password"];
    return [AESCrypt decrypt:temp password:@"pwd"];
}
-(void)saveUID:(int)uid
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"UID"];
    [setting setObject:[NSString stringWithFormat:@"%d", uid] forKey:@"UID"];
    [setting synchronize];
}
-(int)getUID
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:@"UID"];
    if (value && [value isEqualToString:@""] == NO) 
    {
        return [value intValue];
    }
    else
    {
        return 0;
    }
}

-(void)saveUserInfo:(NSString *)key withvalue:(NSString *)value
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:key];
    [setting setObject:value forKey:key];
    [setting synchronize];
}

-(NSString *) getUserInfo:(NSString*)key{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:key];
}

- (void) saveCartToken:(NSString *)token{
    [self saveUserInfo:@"cartToken" withvalue:token];
    [SESSION getSession].cartToken = token;
}

- (void) saveCartId:(int)cartId{
    [self saveUserInfo:@"cartId" withvalue:[NSString stringWithFormat:@"%d",cartId]];
    [SESSION getSession].cartId = cartId;
}


-(int)getSessionID
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:@"SESSIONID"];
    return value;
}
-(void)saveCookie:(BOOL)_isLogin
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"cookie"];
    [setting setObject:isLogin ? @"1" : @"0" forKey:@"cookie"];
    [setting synchronize];
}
-(BOOL)isCookie
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"cookie"];
    if (value && [value isEqualToString:@"1"]) {
        return YES;
    }
    else 
    {
        return NO;
    }
}
static Config * instance = nil;
+(Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            instance = [self new];
        }
    }
    return instance;
}
@end
