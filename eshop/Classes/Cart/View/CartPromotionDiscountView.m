//
//  CartPromotionDiscountView.m
//  eshop
//
//  Created by mc on 16/7/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CartPromotionDiscountView.h"

@implementation CartPromotionDiscountView

- (instancetype)initWithFrame:(CGRect)frame promotionDesc:(NSString *)promotionDesc discountMoney:(NSNumber *)discountMoney{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 1, 30)];
        line.backgroundColor = [UIColor lightGrayColor];
//        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:line];
        
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_onemoredisc.png"]];
        image.frame = CGRectMake(65, 30, 10,10 );
        [self addSubview:image];
        
        UIButton *lbPromotionDesc = [UIButton buttonWithType:UIButtonTypeCustom];
        lbPromotionDesc.frame = CGRectMake(CGRectGetMaxX(image.frame)+5,CGRectGetMinY(image.frame)-5, 140, 26);
//        [lbPromotionDesc setTitle:@"指定商品第2件5折" forState:UIControlStateNormal];
        if (promotionDesc) {
            [lbPromotionDesc setTitle:promotionDesc forState:UIControlStateNormal];
        }
        [lbPromotionDesc setBackgroundImage:[UIImage imageNamed:@"onemoredisc"] forState:UIControlStateNormal];
        [lbPromotionDesc setTitleColor:[UIColor colorWithRed:240/255.0 green:180/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
        lbPromotionDesc.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbPromotionDesc];
        
        UILabel *lbDiscountMoney = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width -10 -100,CGRectGetMinY(lbPromotionDesc.frame)+3, 100, 21)];
//        lbDiscountMoney.text = @"没有优惠";
        if (discountMoney) {
            // @"已优惠 "
            NSString *cartVC_lbDiscountMoney_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_lbDiscountMoney_title"];
            lbDiscountMoney.text = [cartVC_lbDiscountMoney_title stringByAppendingString:[NSString stringWithFormat:@"%@",discountMoney]];
        }
        lbDiscountMoney.textColor = [UIColor blackColor];
        lbDiscountMoney.font = [UIFont systemFontOfSize:10];
        lbDiscountMoney.textAlignment = NSTextAlignmentRight;
        [self addSubview:lbDiscountMoney];
    }
    return self;
}
@end
