//
//  MsgListCell.m
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "MsgListCell.h"

@implementation MsgListCell
@synthesize title;
@synthesize date;
- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
