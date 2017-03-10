//
//  AppMessage.h
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppMessage : BaseModel
@property int id;

/** 标题 */
@property NSString* title;

/** 内容 */
@property NSString* content;

/** ip */
@property NSString* ip;

/** 是否为草稿 */
@property Boolean isDraft;

/** 发件人已读 */
@property Boolean senderRead;

/** 收件人已读 */
@property Boolean receiverRead;

/** 发件人删除 */
@property Boolean senderDelete;

/** 收件人删除 */
@property Boolean receiverDelete;

/** 发件人 */
@property int senderId;

@property NSString* senderName;


/** 收件人 */
@property int receiverId;

@property NSString* receiverName;

/** 原消息 */
@property int forMessageId;

@property NSDate* createDate;

@end
