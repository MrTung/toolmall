//
//  GiftView.h
//  eshop
//
//  Created by mc on 16/7/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
//购物车，促销商品赠送的礼品
@interface GiftView : UIView

@property (nonatomic ,strong) EGOImageView * giftImage;

- (instancetype)initWithFrame:(CGRect)frame giftImage:(NSString *)giftImage giftName:(NSString *)giftName giftSpec:(NSString *)giftSpec giftPrice:(NSNumber *)giftPrice giftAmount:(int)giftAmount meetDemands:(NSString *)meetDemands;



@end
