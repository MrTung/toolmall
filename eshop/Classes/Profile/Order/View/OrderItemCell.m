//
//  OrderItemCell.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderItemCell.h"

//#import "Masonry.h"

@implementation OrderItemCell
@synthesize lbProdName;
@synthesize lbOldPrice;
@synthesize lbProdSize;
@synthesize lbPrice;
@synthesize lbQuantity;
@synthesize image;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(TMScreenH *5/568.0);
        make.left.equalTo(self.mas_left).offset(TMScreenW *8/320.0);
        make.width.mas_equalTo(TMScreenW *75/320.0);
        make.height.mas_equalTo(TMScreenW *75/320.0);
    }];
    [self.lbProdName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(TMScreenH *7/568.0);
        make.left.equalTo(self.image.mas_right).offset(TMScreenW *5/320.0);
        make.width.mas_equalTo(TMScreenW *170/320);
        make.height.mas_equalTo(TMScreenH *35/568.0);
    }];
    [self.lbQuantity mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.lbProdName.mas_centerY).offset(TMScreenH *0/568.0);
        make.right.equalTo(self.mas_right).offset(-TMScreenW *10/320.0);
        make.width.mas_equalTo(TMScreenW *50/320);
        make.height.mas_equalTo(TMScreenH *20/568.0);
    }];
    [self.lbProdSize mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdName.mas_bottom).offset(TMScreenH *3/568.0);
        make.left.equalTo(self.image.mas_right).offset(TMScreenW *5/320.0);
        make.right.equalTo(self.mas_right).offset(-TMScreenW *10/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    [self.lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdSize.mas_bottom).offset(TMScreenH *3/568.0);
        make.left.equalTo(self.image.mas_right).offset(TMScreenW *5/320.0);
        make.width.equalTo(self.lbProdSize.mas_width).multipliedBy(0.5).offset(- TMScreenW *5/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    [self.lbOldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdSize.mas_bottom).offset(TMScreenH *3/568.0);
        make.right.equalTo(self.mas_right).offset(- TMScreenW *10/320.0);
        make.width.equalTo(self.lbProdSize.mas_width).multipliedBy(0.5).offset(- TMScreenW *10/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(TMScreenW *0/320);
        make.right.equalTo(self.mas_right).offset(-TMScreenW *0/320);
        make.bottom.equalTo(self.mas_bottom).offset(- TMScreenH *0/568);
        make.height.mas_equalTo(TMScreenH *1/568);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)myinit{
    [CommonUtils decrateImageGaryBorder:self.image];
}
@end
