//
//  BrandGoodsCollectionViewCell.m
//  eshop
//
//  Created by gs_sh on 17/2/14.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BrandGoodsCollectionViewCell.h"

@interface BrandGoodsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet EGOImageView *goodsImg;
@property (weak, nonatomic) IBOutlet EGOImageView *hotImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *addtocartBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *topLab;

@end

@implementation BrandGoodsCollectionViewCell

- (void)setProduct:(AppProduct *)product {

    self.hotImg.hidden = YES;
    self.goodsImg.placeholderImage = [UIImage imageNamed:@"defaultImg.png"];
    self.goodsImg.imageURL = [URLUtils createURL:product.image];
    self.contentLabel.text = product.fullName;
//    cell.title1.numberOfLines = 2;
//    cell.title1.lineBreakMode = NSLineBreakByCharWrapping;
    
//    self.nowPriceLab.text = [CommonUtils formatCurrency:product.price];
    self.nowPriceLab.attributedText = [CommonUtils getFormatCurrencyAttributedStringFromString:[CommonUtils formatCurrency:product.price] isDelegate:NO];
    if (product.promotionPrice) {
        
//        self.nowPriceLab.text = [CommonUtils formatCurrency:product.promotionPrice];
        self.nowPriceLab.attributedText = [CommonUtils getFormatCurrencyAttributedStringFromString:[CommonUtils formatCurrency:product.promotionPrice] isDelegate:NO];
//        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@元",product.price]];
//        [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
//        
//        [att addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:8.0] range:NSMakeRange(0, 1)];
        
        self.oldPriceLab.attributedText = [CommonUtils getFormatCurrencyAttributedStringFromString:[CommonUtils formatCurrency:product.price] isDelegate:YES];
    }

    if (product.isHotSale) {
        self.hotImg.hidden = NO;
        self.hotImg.image = [UIImage imageNamed:@"hotImg.png"];
    }
    self.topLabHeightLayout.constant = kWidth *15/750;
    self.topLab.backgroundColor = groupTableViewBackgroundColorSelf;
}

- (IBAction)clickAddToCart:(id)sender {

    Message * msg = [[Message alloc] init];
    msg.what = 1;
    msg.int1 = self.productId;
    [self.msgHandler sendMessage:msg];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
