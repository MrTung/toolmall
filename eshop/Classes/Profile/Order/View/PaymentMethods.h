//
//  PaymentMethods.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPaymentMethod.h"
#import "OrderController.h"

@protocol PaymentMethodsDelegate <NSObject>

- (void)returnPaymentMethodName:(NSString *)paymentMethodName;
@end

@interface PaymentMethods : UIBaseController

@property (nonatomic, weak) id <PaymentMethodsDelegate> paymentMethodDelegate;
@property (nonatomic) IBOutlet UITableView *tableList;
@property NSMutableArray *paymentMethods;
@end
