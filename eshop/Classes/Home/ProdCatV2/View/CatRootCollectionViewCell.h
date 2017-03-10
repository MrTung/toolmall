//
//  CatRootCollectionViewCell.h
//  eshop
//
//  Created by sh on 16/9/29.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppProductCategory.h"

@interface CatRootCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setProdCategory:(AppProductCategory *) prodCategory;


@end
