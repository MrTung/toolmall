//
//  BrandIconCollectionViewCell.h
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandIconCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *iconImg;
@property (nonatomic, copy) NSString *logoUrl;

@end
