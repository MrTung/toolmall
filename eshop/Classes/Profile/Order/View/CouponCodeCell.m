//
//  CouponCodeCell.m
//  eshop
//
//  Created by mc on 15/11/9.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CouponCodeCell.h"

@interface CouponCodeCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CouponCodeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    // 有效期:
    NSString *couponCodeCell_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeCell_label_title"];
    self.label.text = couponCodeCell_label_title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
