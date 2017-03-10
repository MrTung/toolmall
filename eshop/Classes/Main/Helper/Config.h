//
//  Config.h
//  oschina
//
//  Created by wangjun on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma api地址

//是否已经登录
@property BOOL isLogin;

@property (retain, nonatomic) UIViewController * viewBeforeLogin;
@property (copy, nonatomic) NSString * viewNameBeforeLogin;

//是否具备网络链接
@property BOOL isNetworkRunning;


//动弹缓存
@property (retain, nonatomic) UIImage * tweetCachePic;
@property (copy, nonatomic) NSString * tweet;
//问答缓存
@property (copy,nonatomic) NSString * questionTitle;
@property (copy,nonatomic) NSString * questionContent;
@property int questionIndex;
//留言缓存
@property (retain,nonatomic) NSMutableDictionary * msgs;
-(void)saveMsgCache:(NSString *)msg andUID:(int)uid;
-(NSString *)getMsgCache:(int)uid;
//评论缓存
@property (retain,nonatomic) NSMutableDictionary * comments;
-(void)saveCommentCache:(NSString *)comment andCommentID:(int)commentID;
-(NSString *)getCommentCache:(int)commentID;
//回复评论缓存
@property (retain,nonatomic) NSMutableDictionary * replies;
-(void)saveReplyCache:(NSString *)reply andCommentID:(int)commentID andReplyID:(int)replyID;
-(NSString *)getReplyCache:(int)commentID andReplyID:(int)replyID;

//保存登录用户名以及密码
-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
-(NSString *)getUserName;
-(NSString *)getPwd;
-(void)saveUID:(int)uid;
-(int)getUID;
-(void)savePostPubNoticeMe:(BOOL)isNotice;
-(BOOL)isPostPubNoticeMe;
-(void)saveCookie:(BOOL)_isLogin;
-(BOOL)isCookie;

-(void)saveIsPostToMyZone:(BOOL)isToMyZone;
-(BOOL)getIsPostToMyZone;

-(void)savePubPostCatalog:(int)catalog;
-(int)getPubPostCatalog;

-(NSString *)getIOSGuid;

-(void)saveUserInfo:(NSString *)key withvalue:(NSString *)value;
-(NSString *) getUserInfo:(NSString*)key;
- (void) saveCartToken:(NSString *)token;
- (void) saveCartId:(int)cartId;
+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
