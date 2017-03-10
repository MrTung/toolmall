//
//  OrderItemHeader.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderItemHeader.h"

@interface OrderItemHeader ()
@property (weak, nonatomic) IBOutlet UIView *bacView;
@end

@implementation OrderItemHeader
@synthesize merchantName;

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self.merchantName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bacView.mas_top).offset(TMScreenH *0/568);
        make.left.equalTo(self.bacView.mas_left).offset(TMScreenW *8/320);
        make.width.mas_equalTo(TMScreenW *304/320);
        make.height.mas_equalTo(TMScreenH *25/568);
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
