//
//  PluginService.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "PaymentPluginListResponse.h"
@interface PluginService : BaseService
- (void)getPaymentPlugins;
@end
