//
//  ShippingMethods.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppShippingMethod.h"
#import "ShippingMethodCell.h"
#import "OrderController.h"
@interface ShippingMethods : UIBaseController<UITableViewDataSource, UITableViewDelegate>{
   
}

@property (nonatomic) IBOutlet UITableView *tableShippingMethods;
@property NSMutableArray *shippingMethods;
@property NSInteger section;
@end
