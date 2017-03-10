//
//  DetailBrandsHeaderView.m
//  eshop
//
//  Created by gs_sh on 17/2/14.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "DetailBrandsHeaderView.h"

@interface DetailBrandsHeaderView ()

@property (weak, nonatomic) IBOutlet EGOImageView *brandsImg;
@property (weak, nonatomic) IBOutlet UILabel *brandsBrief;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightLayoutConstraint;

@end

@implementation DetailBrandsHeaderView

- (void)setAppBrand:(AppBrand *)appBrand {
    
    if (appBrand) {
        
        self.brandsImg.placeholderImage = [UIImage imageNamed:@"defaultImg_small.png"];
        self.brandsImg.imageURL = [URLUtils createURL:appBrand.logo];

        self.brandsBrief.attributedText = [CommonUtils getAttributedString:appBrand.brief font:self.brandsBrief.font lineSpacing:0];
        self.brandsBrief.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    self.viewHeightLayoutConstraint.constant = kHeight *125/667;
}
@end
