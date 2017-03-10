//
//  OrderInfoCell.m
//  eshop
//
//  Created by mc on 15/11/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderInfoCell.h"

//#import "Masonry.h"

@implementation OrderInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.prodImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(TMScreenH *5/568.0);
        make.left.equalTo(self.mas_left).offset(TMScreenW *8/320.0);
        make.width.mas_equalTo(TMScreenW *75/320.0);
        make.height.mas_equalTo(TMScreenW *75/320.0);
    }];
    [self.lbProdName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(TMScreenH *7/568.0);
        make.left.equalTo(self.prodImage.mas_right).offset(TMScreenW *5/320.0);
        make.width.mas_equalTo(TMScreenW *180/320);
        make.height.mas_equalTo(TMScreenH *35/568.0);
    }];
    [self.lbQuantity mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.lbProdName.mas_centerY).offset(TMScreenH *0/568.0);
        make.right.equalTo(self.mas_right).offset(-TMScreenW *5/320.0);
        make.width.mas_equalTo(TMScreenW *40/320);
        make.height.mas_equalTo(TMScreenH *20/568.0);
    }];
    [self.lbProdSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdName.mas_bottom).offset(TMScreenH *3/568.0);
        make.left.equalTo(self.prodImage.mas_right).offset(TMScreenW *5/320.0);
        make.right.equalTo(self.mas_right).offset(-TMScreenW *5/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    [self.lbProdPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdSpec.mas_bottom).offset(TMScreenH *3/568.0);
        make.left.equalTo(self.prodImage.mas_right).offset(TMScreenW *5/320.0);
        make.width.equalTo(self.lbProdSpec.mas_width).multipliedBy(0.5).offset(- TMScreenW *5/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    [self.lbMarketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lbProdSpec.mas_bottom).offset(TMScreenH *3/568.0);
        make.right.equalTo(self.mas_right).offset(- TMScreenW *5/320.0);
        make.width.equalTo(self.lbProdSpec.mas_width).multipliedBy(0.5).offset(- TMScreenW *5/320.0);
        make.height.mas_equalTo(TMScreenH *15/568.0);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderItem:(AppOrderItem *)orderItem{
    [CommonUtils decrateImageGaryBorder:self.prodImage];
    if (orderItem.thumbnail != nil){
        self.prodImage.imageURL = [[NSURL alloc] initWithString:orderItem.thumbnail];
    }
    self.lbProdName.text = orderItem.name;
    [self.lbProdName alignTop];
    self.lbProdSpec.text = orderItem.appProduct.specificationName;
    self.lbProdPrice.textColor = TMRedColor;
//    redColorSelf
    
    self.lbQuantity.text = [[NSString alloc] initWithFormat:@"X%d", orderItem.quantity];
    
    if (orderItem.displayPrice){
        self.lbProdPrice.text = [CommonUtils formatCurrency:orderItem.finalPrice];
        self.lbMarketPrice.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:orderItem.price]];
    } else {
        self.lbProdPrice.text = [CommonUtils formatCurrency:orderItem.price];
        self.lbMarketPrice.hidden = YES;
    }
    
//    将赠送的礼品信息附带上
    
    if (orderItem.giftItems) {
        for (int i=0; i<orderItem.giftItems.count; i++) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.prodImage.frame), CGRectGetMaxY(self.prodImage.frame) + i * TMScreenH *20/568.0, self.frame.size.width - TMScreenW *10/320.0, TMScreenH *20/568.0)];
            [label setFont:[UIFont systemFontOfSize:12]];
            [label setTextColor:TMBlackColor];
            AppGiftItem * giftItem = orderItem.giftItems[i];
//            [@"[赠品]" stringByAppendingString:[NSString stringWithFormat:@" %@ X%d",giftItem.name,giftItem.quantity]]
            // @"[赠品] %@ X%d"
            NSString *orderInfoCell_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoCell_label_title"];
            NSString *str = [NSString stringWithFormat:orderInfoCell_label_title, giftItem.name,giftItem.quantity];
            label.text = str;
            [self.contentView addSubview:label];
        }
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, TMScreenH *85/568.0 + (TMScreenH *20/568.0) * orderItem.giftItems.count)];
    }else {
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, TMScreenH *85/568.0)];
    }
}

@end
