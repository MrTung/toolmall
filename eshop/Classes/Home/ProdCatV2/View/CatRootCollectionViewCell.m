//
//  CatRootCollectionViewCell.m
//  eshop
//
//  Created by sh on 16/9/29.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CatRootCollectionViewCell.h"

@implementation CatRootCollectionViewCell

- (void)setProdCategory:(AppProductCategory *) prodCategory{
    
    self.imgView.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    self.imgView.imageURL = [URLUtils createURL:prodCategory.image];
    self.titleLabel.text = prodCategory.name;
    self.contentLabel.text = prodCategory.subName;
}

@end
