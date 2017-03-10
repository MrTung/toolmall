//
//  BrandGoodsCollectionViewCell.h
//  eshop
//
//  Created by gs_sh on 17/2/14.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) AppProduct *product;

@property (nonatomic, weak) id<MsgHandler> msgHandler;

@property (nonatomic, assign) int productId;

@end
