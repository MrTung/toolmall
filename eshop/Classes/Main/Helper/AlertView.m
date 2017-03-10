//
//  AlertView.m
//  AlertViewTest
//
//  Created by MacBook on 16/5/4.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "AlertView.h"

#define HScreenHeight [UIScreen mainScreen].bounds.size.height
#define WScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation AlertView

+ (void)showMessage:(NSString *)message {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView *showview =  [[UIView alloc]init];
    
    showview.backgroundColor = [UIColor blackColor];
    
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    
    showview.layer.cornerRadius = 8.0f;
    
    showview.layer.masksToBounds = YES;
    
    [window addSubview:showview];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(WScreenWidth * 120/320, HScreenHeight * 80/568)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
//                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
//    CGSize LabelSize = [message sizeWithAttributes:<#(nullable NSDictionary<NSString *,id> *)#>]
    
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    
    label.text = message;
    
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = 1;
    
    label.backgroundColor = [UIColor clearColor];
    
    label.font = [UIFont boldSystemFontOfSize:15];
    
    [showview addSubview:label];
    
    //提示框的位置
    showview.frame = CGRectMake((WScreenWidth - LabelSize.width - 20)/2, HScreenHeight/2 - HScreenHeight * 150/568, LabelSize.width+20, LabelSize.height+10);
    
    [UIView animateWithDuration:1.5 animations:^{
        
        showview.alpha = 0.7;
//        showview.frame = CGRectMake((WScreenWidth - LabelSize.width - 20)/2, HScreenHeight/2 - HScreenHeight * 150/568, LabelSize.width+20, LabelSize.height+10);
        
    } completion:^(BOOL finished) {
        
        [showview removeFromSuperview];
        
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
