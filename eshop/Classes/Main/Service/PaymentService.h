//
//  PaymentService.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "OnlinePayResponse.h"

@interface PaymentService : BaseService

- (void) onlinePay:(NSString*)type paymentPluginId:(NSString*) paymentPluginId sn:(NSString*)sn  amount:(NSNumber*) amount;


@end
