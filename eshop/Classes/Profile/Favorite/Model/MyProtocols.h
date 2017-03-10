//
//  MyProtocols.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
@protocol MsgHandler <NSObject>

- (void)sendMessage:(Message*)msg;

@end

@interface MyProtocols : NSObject

@end
