//
//  BaseModel.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface BaseModel : Jastor

- (NSString *)toJsonString;
@property (nonatomic, copy) NSString *paymentPluginId;

@end
