//
//  OrderListItemHeader.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderListItemHeader.h"

@interface OrderListItemHeader ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation OrderListItemHeader
@synthesize orderSn;
@synthesize orderStatus;

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // 订单编号:
    NSString *orderListItemHeader_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemHeader_label_title"];
    self.label.text = orderListItemHeader_label_title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
