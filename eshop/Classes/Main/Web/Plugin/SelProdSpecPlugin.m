//
//  SelProdSpecPlugin.m
//  eshop
//
//  Created by mc on 16/3/10.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "SelProdSpecPlugin.h"
static id<MsgHandler> msgHandler;
@implementation SelProdSpecPlugin
+ (id<MsgHandler>)MSG_HANDLER{
    return msgHandler;
}
+ (void)setMSG_HANDLER:(id<MsgHandler>)handler{
    msgHandler = handler;
}
- (void)execute:(CDVInvokedUrlCommand*)command
{
    NSString* value0 = [NSString stringWithFormat:@"%@(%@)", [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"] ,[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value0];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)selProdSpecifications:(CDVInvokedUrlCommand*)command{
    Message *msg = [[Message alloc] init];
    msg.what = 1;
    msg.obj = command.arguments;
    [[SelProdSpecPlugin MSG_HANDLER] sendMessage:msg];
}
- (void)addToCart:(CDVInvokedUrlCommand*)command{
    Message *msg = [[Message alloc] init];
    msg.what = 2;
    msg.obj = command.arguments;
    [[SelProdSpecPlugin MSG_HANDLER] sendMessage:msg];
}
@end
