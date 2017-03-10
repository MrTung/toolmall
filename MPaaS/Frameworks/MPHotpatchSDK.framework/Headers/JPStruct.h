//
//  JPStruct.h
//  JSHotpatchSDK
//
//  Created by pc on 16/6/30.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import "JPEngine.h"

@interface JPStruct : JPExtension

+ (void)setStructData:(void *)structData withOffset:(int)offset value:(id)obj type:(char)typeCode;

@end
