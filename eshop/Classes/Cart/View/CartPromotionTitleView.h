//
//  CartPromotionTitleView.h
//  eshop
//
//  Created by mc on 16/7/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
//购物车商品促销的标题

@protocol CartPromotionTitleViewDelegate <NSObject>

- (void)clickOnCartPromotionTitleView:(id)object;

@end

@interface CartPromotionTitleView : UIView
@property (nonatomic, strong) UIImageView * image;
@property(nonatomic, strong) UIButton * btnClickToPromotion;
@property (weak, nonatomic) id<CartPromotionTitleViewDelegate>cartProTitleDelegate;

-(instancetype)initWithFrame:(CGRect)frame hasPromotion:(BOOL)hasPromotion title:(NSString *)title type:(NSString *)type;


@end
