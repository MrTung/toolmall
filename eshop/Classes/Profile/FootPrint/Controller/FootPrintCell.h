//
//  FootPrintCell.h
//  eshop
//
//  Created by mc on 16/5/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "AppProduct.h"
@interface FootPrintCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *imageview;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *productBrand;

@property (weak, nonatomic) IBOutlet UILabel *productModel;

@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (weak, nonatomic) IBOutlet UILabel *productOldPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnHotSale;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCar;

+ (void)configInfomation:(AppProduct *)product;


@end
