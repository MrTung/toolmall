//
//  ProdTableCellTable.m
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "ProdTableCellTable.h"

@implementation ProdTableCellTable
@synthesize name1;
@synthesize brand1;
@synthesize makerModel1;
@synthesize sn1;
@synthesize price1;
@synthesize addtocart1;
@synthesize image1;

@synthesize name2;
@synthesize brand2;
@synthesize makerModel2;
@synthesize sn2;
@synthesize price2;
@synthesize addtocart2;
@synthesize image2;

@synthesize msgHandler;
@synthesize productId1;
@synthesize productId2;

@synthesize imageBorderView1;
@synthesize imageBorderView2;

@synthesize bgView1;
@synthesize bgView2;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)myinit{
    //[CommonUtils decrateGaryButton:self.addtocart1];
    //[CommonUtils decrateGaryButton:self.addtocart2];
    [CommonUtils decrateViewGaryBorder:self.imageBorderView1];
    [CommonUtils decrateViewGaryBorder:self.imageBorderView2];
    self.image1.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    self.image2.placeholderImage = [UIImage imageNamed:@"index_defImage"];
}


- (IBAction)clickAddToCart:(UIButton *)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 1;
    if (sender.tag == 1){
        msg.int1 = productId1;
    } else{
        msg.int1 = productId2;
    }
    [msgHandler sendMessage:msg];
}

- (IBAction)clickProdBgView:(UIControl *)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 2;
    msg.int1 = sender.tag;
    [msgHandler sendMessage:msg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
