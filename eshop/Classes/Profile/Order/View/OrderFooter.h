//
//  OrderFooter.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFooter : UIView

//合计金额
@property (nonatomic) IBOutlet UILabel *lbAmount;
//立即购买按钮
@property (nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic) id<MsgHandler> msgHandler;

- (void)myinit;

@end
