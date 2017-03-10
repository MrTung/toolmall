//
//  ActivityCell.m
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ActivityCell.h"

@interface ActivityCell ()


@end

@implementation ActivityCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.image1.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    self.image2.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    
    [self.viewBG1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(TMScreenH *2/568);
        make.bottom.equalTo(self.mas_bottom).offset(- TMScreenH *2/568);
        make.left.equalTo(self.mas_left).offset(TMScreenW *0/320);
        make.width.equalTo(self.mas_width).multipliedBy(0.5).offset(- TMScreenW *2/320);
    }];
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.viewBG1.mas_top);
        make.left.equalTo(self.viewBG1.mas_left);
        make.width.equalTo(self.viewBG1.mas_width);
        make.height.equalTo(self.viewBG1.mas_width);
        
    }];
    [self.hotImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.viewBG1.mas_top);
        make.left.equalTo(self.viewBG1.mas_left);
        make.width.equalTo(self.viewBG1.mas_width).multipliedBy(0.22);
        make.height.equalTo(self.hotImg1.mas_width);
    }];
    [self.cutView1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.image1.mas_bottom);
        make.left.equalTo(self.viewBG1.mas_left);
        make.right.equalTo(self.viewBG1.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.cutView1.mas_bottom).offset(TMScreenH *5/568);
        make.left.equalTo(self.viewBG1.mas_left).offset(TMScreenW *8/320);
        make.right.equalTo(self.viewBG1.mas_right).offset(-TMScreenW *8/320);
        make.height.equalTo(self.viewBG1.mas_height).multipliedBy(40.0/235);
    }];
    [self.price1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.title1.mas_bottom).offset(TMScreenH *5/568);
        make.left.equalTo(self.viewBG1.mas_left).offset(TMScreenW *8/320);
        make.width.equalTo(self.viewBG1.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.viewBG1.mas_height).multipliedBy(20.0/235);
    }];
    [self.oldPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.title1.mas_bottom).offset(TMScreenH *5/568);
        make.right.equalTo(self.viewBG1.mas_right).offset(- TMScreenW *8/320);
        make.width.equalTo(self.viewBG1.mas_width).multipliedBy(0.4);
        make.height.equalTo(self.viewBG1.mas_height).multipliedBy(20.0/235);
        
    }];
    
    
    [self.viewBG2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(TMScreenH *2/568);
        make.bottom.equalTo(self.mas_bottom).offset(- TMScreenH *2/568);
        make.left.equalTo(self.viewBG1.mas_right).offset(TMScreenW *4/320);
        make.width.equalTo(self.viewBG1.mas_width);
//        make.right.equalTo (self.mas_right).offset(0);
    }];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.viewBG2.mas_top);
        make.left.equalTo(self.viewBG2.mas_left);
        make.width.equalTo(self.viewBG2.mas_width);
        make.height.equalTo(self.viewBG2.mas_width);
        
    }];
    [self.hotImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.viewBG2.mas_top);
        make.left.equalTo(self.viewBG2.mas_left);
        make.width.equalTo(self.viewBG2.mas_width).multipliedBy(0.22);
        make.height.equalTo(self.hotImg2.mas_width);
    }];
    [self.cutView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image2.mas_bottom);
        make.left.equalTo(self.viewBG2.mas_left);
        make.right.equalTo(self.viewBG2.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.cutView2.mas_bottom).offset(TMScreenH *5/568);
        make.left.equalTo(self.viewBG2.mas_left).offset(TMScreenW *8/320);
        make.right.equalTo(self.viewBG2.mas_right).offset(-TMScreenW *8/320);
        make.height.equalTo(self.viewBG2.mas_height).multipliedBy(40.0/235);
    }];
    [self.price2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title2.mas_bottom).offset(TMScreenH *5/568);
        make.left.equalTo(self.viewBG2.mas_left).offset(TMScreenW *8/320);
        make.width.equalTo(self.viewBG2.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.viewBG2.mas_height).multipliedBy(20.0/235);
    }];
    [self.oldPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title2.mas_bottom).offset(TMScreenH *5/568);
        make.right.equalTo(self.viewBG2.mas_right).offset(- TMScreenW *8/320);
        make.width.equalTo(self.viewBG2.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.viewBG2.mas_height).multipliedBy(20.0/235);
        
    }];
}

-(void)setItem:(AppProduct *)productItem row:(NSInteger)row appProducts:(NSMutableArray*)appProducts
{
    self.image1.imageURL = [URLUtils createURL:productItem.image];
    self.title1.text = productItem.fullName;
    self.title1.numberOfLines = 2;
    self.title1.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.price1.text = [CommonUtils formatCurrency:productItem.price];
    if (productItem.promotionPrice) {
        self.price1.text = [CommonUtils formatCurrency:productItem.promotionPrice];
        self.oldPrice1.hidden = NO;
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@元",productItem.price]];
        [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
        self.oldPrice1.attributedText = att;
    }
    self.btnTouch1.tag = productItem.id;
    
    if (appProducts.count > row + 1){
        productItem =[appProducts objectAtIndex:row + 1];
        if (productItem) {
            self.image2.imageURL = [URLUtils createURL:productItem.image];
            self.title2.numberOfLines = 2;
            self.title2.lineBreakMode = NSLineBreakByCharWrapping;
            self.title2.text = productItem.fullName;
            self.price2.text = [CommonUtils formatCurrency:productItem.price];
            if (productItem.promotionPrice) {
                self.price2.text = [CommonUtils formatCurrency:productItem.promotionPrice];
                self.oldPrice2.hidden = NO;
                NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@元",productItem.price]];
                [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
                self.oldPrice2.attributedText = att;
            }
            
            self.btnTouch2.tag = productItem.id;
        }else{
            self.viewBG2.hidden = YES;
        }
        
    }
}
@end
