//
//  CartPromotionTitleView.m
//  eshop
//
//  Created by mc on 16/7/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CartPromotionTitleView.h"

@implementation CartPromotionTitleView
@synthesize cartProTitleDelegate;

- (instancetype)initWithFrame:(CGRect)frame hasPromotion:(BOOL)hasPromotion title:(NSString *)title type:(NSString *)type{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        UILabel * lbPromotionTitle = [[UILabel alloc] init];
        lbPromotionTitle.text = @"";
        if (title) {
            lbPromotionTitle.text = title;
        }
        lbPromotionTitle.textColor = [UIColor blackColor];
        lbPromotionTitle.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbPromotionTitle];
        
        if(hasPromotion == YES){
            
            UILabel * lbFullToReduce = [[UILabel alloc] init ];
            lbFullToReduce.text = type;
            lbFullToReduce.textAlignment = NSTextAlignmentCenter;
            lbFullToReduce.textColor = [UIColor whiteColor];
            lbFullToReduce.adjustsFontSizeToFitWidth = YES;
            lbFullToReduce.layer.masksToBounds = YES;
            lbFullToReduce.layer.borderColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:218/255.0 alpha:1].CGColor;
            lbFullToReduce.layer.borderWidth = SINGLE_LINE_WIDTH;
            lbFullToReduce.font = [UIFont systemFontOfSize:10];

            CGFloat buttonWidth = [type sizeWithFont:lbFullToReduce.font
                                    constrainedToSize:CGSizeMake(150, 28)
                                        lineBreakMode:UILineBreakModeClip].width;
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(35, frame.size.height/2.0 -20/2.0, 20 + buttonWidth, 20)];
            
            view.backgroundColor = [UIColor colorWithRed:200/255.0 green:0 blue:20/255.0 alpha:1];
            [self addSubview:view];
            
            lbFullToReduce.frame = CGRectMake(2, 2, 16+buttonWidth, 16);
            [view addSubview:lbFullToReduce];
            
            lbPromotionTitle.frame = CGRectMake(CGRectGetMaxX(view.frame) +5, 0, frame.size.width - CGRectGetMaxX(view.frame) - 20, frame.size.height);
            
        }else{
            lbPromotionTitle.frame = CGRectMake(35, 0, frame.size.width - 45, frame.size.height);
        }
        
        self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_right_arrow"]];
        self.image.frame = CGRectMake(frame.size.width - 20, (frame.size.height -15)/2.0, 10, 15);
        [self addSubview:self.image];
        
        _btnClickToPromotion = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnClickToPromotion.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_btnClickToPromotion];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([self respondsToSelector:@selector(clickOnCartPromotionTitleView:)]) {
        [cartProTitleDelegate performSelector:@selector(clickOnCartPromotionTitleView:)];
    }
}


@end
