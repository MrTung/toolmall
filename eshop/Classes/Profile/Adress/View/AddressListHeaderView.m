//
//  AddressListHeaderView.m
//  eshop
//
//  Created by gs_sh on 17/2/9.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "AddressListHeaderView.h"

@interface AddressListHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightLayoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *addAddressLabel;

@end

@implementation AddressListHeaderView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // @"添加新地址"
    NSString *addressListHeaderView_addAddressLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressListHeaderView_addAddressLabel_title"];
    self.addAddressLabel.text = addressListHeaderView_addAddressLabel_title;
    self.headerHeightLayoutConstraint.constant = kHeight * 40/568;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
