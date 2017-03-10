//
//  OrderItemCell.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell

@property (nonatomic) IBOutlet EGOImageView *image;
@property (nonatomic) IBOutlet UILabel *lbProdName;
@property (nonatomic) IBOutlet UILabel *lbQuantity;
@property (nonatomic) IBOutlet UILabel *lbProdSize;
@property (nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

- (void)myinit;
@end
