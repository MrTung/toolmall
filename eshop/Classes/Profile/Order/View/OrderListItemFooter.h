//
//  OrderListItemFooter.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOrderInfo.h"

@protocol OrderListItemFooterDelegate <NSObject>

- (void) sendMessage:(NSInteger)tagId section:(NSInteger)section;

@end

@interface OrderListItemFooter : UITableViewHeaderFooterView
@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UILabel *lnFooterDesc;
@property NSInteger section;
@property id<OrderListItemFooterDelegate> footerDelegate;
- (CGFloat)displayButtons:(AppOrderInfo*)orderInfo;
@end
