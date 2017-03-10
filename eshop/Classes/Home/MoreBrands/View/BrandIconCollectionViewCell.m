//
//  BrandIconCollectionViewCell.m
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BrandIconCollectionViewCell.h"

@implementation BrandIconCollectionViewCell

- (void)setLogoUrl:(NSString *)logoUrl {
    
    self.iconImg.placeholderImage = [UIImage imageNamed:@"defaultImg_small.png"];
    self.iconImg.imageURL = [URLUtils createURL:logoUrl];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
