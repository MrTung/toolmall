//
//  OpinionCell.m
//  eshop
//
//  Created by mc on 16/4/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "OpinionCell.h"

@implementation OpinionCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    // @"您可以根据您的商品质量，使用情况，材质，服务等情况作出评价，满意请给好评！"
    NSString *opinionCell_content_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"opinionCell_content_plaTitle"];
    self.content.placeholderText = opinionCell_content_plaTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
