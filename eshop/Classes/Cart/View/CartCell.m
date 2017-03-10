//
//  CartItemCell.m
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "CartCell.h"
//#import "AlertView.h"
#import "IQUIView+IQKeyboardToolbar.h"
@implementation CartCell

@synthesize btnChk;
@synthesize image;
@synthesize prodname;
@synthesize price;
@synthesize quantity;
@synthesize indexPath;


- (void)awakeFromNib {
    
    [super awakeFromNib];
}
- (void)myinit{
    [btnChk setImage:[UIImage imageNamed:@"newcheckfalse"] forState:UIControlStateNormal];
    [btnChk setImage:[UIImage imageNamed:@"newchecktrue"] forState:UIControlStateSelected];
    
    self.imageHeightLayout.constant = TMScreenH *77/568;
    
    [CommonUtils decrateImageGaryBorder:self.image];
    
    //    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInView:)];
    //    quantity.tag = indexPath;
    //    [self addGestureRecognizer:tap];
    //    quantity.delegate = self;
    
}

//- (void)tapInView:(UITapGestureRecognizer *)tap{
//    UIView * target = tap.view;
//
//    if (target.tag != indexPath) {
//        if ([quantity isFirstResponder]) {
//            quantity.text = quantity.text;
//            [quantity resignFirstResponder];
//            [cartDelegate selectCartItem:indexPath quantity:[quantity.text intValue] selected:btnChk.selected];
//        }
//        else{
////            quantity.enabled = NO;
//        }
//    }
//}

//跳转到满减详情页
- (IBAction)clickPromotionContentToDetail:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)initParentView:(UIView *)view {
    if (view) {
        
        self.parentView = view;
    } else {
        self.parentView = [UIApplication sharedApplication].keyWindow;
    }
}

- (IBAction)clickCheckBox:(id)sender{
    
    btnChk.selected = !btnChk.selected;
    
    [self.cartDelegate selectCartItem:indexPath quantity:[quantity.text intValue] selected:btnChk.selected];
    
}

-(IBAction)clickSub:(id)sender{
    
    if (![quantity.text  isEqual: @"1"]){
        
        quantity.text = [NSString stringWithFormat:@"%d", [quantity.text intValue] - 1 ];
        
        if ([ self.cartDelegate respondsToSelector:@selector(selectCartItem:quantity:selected:)])
            [_cartDelegate selectCartItem:indexPath quantity:[quantity.text intValue] selected:btnChk.selected];
    }
}

-(IBAction)clickAdd:(id)sender{
    
    quantity.text = [NSString stringWithFormat:@"%d", [quantity.text intValue] + 1 ];
    
    if ([ self.cartDelegate respondsToSelector:@selector(selectCartItem:quantity:selected:)]){
        [_cartDelegate selectCartItem:indexPath quantity:[quantity.text intValue] selected:btnChk.selected];
    }

    if ([quantity.text intValue] > [_cartItem.product.availableStock intValue] && _cartItem.product.availableStock) {
        
        quantity.text = [NSString stringWithFormat:@"%@", _cartItem.product.availableStock];
    }
}

@end
