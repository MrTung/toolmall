//
//  ProdTableCellTable.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdTableCellTable : UITableViewCell

@property (nonatomic) IBOutlet UILabel *name1;
@property (nonatomic) IBOutlet UILabel *brand1;
@property (nonatomic) IBOutlet UILabel *makerModel1;
@property (nonatomic) IBOutlet UILabel *sn1;
@property (nonatomic) IBOutlet UILabel *price1;
@property (nonatomic) IBOutlet UILabel *delPrice1;
@property (nonatomic) IBOutlet UIButton *addtocart1;
@property (nonatomic) IBOutlet EGOImageView *image1;
@property (nonatomic) IBOutlet UIImageView *hotImage1;

@property (nonatomic) IBOutlet UILabel *name2;
@property (nonatomic) IBOutlet UILabel *brand2;
@property (nonatomic) IBOutlet UILabel *makerModel2;
@property (nonatomic) IBOutlet UILabel *sn2;
@property (nonatomic) IBOutlet UILabel *price2;
@property (nonatomic) IBOutlet UILabel *delPrice2;
@property (nonatomic) IBOutlet UIButton *addtocart2;
@property (nonatomic) IBOutlet EGOImageView *image2;
@property (nonatomic) IBOutlet UIImageView *hotImage2;

@property (nonatomic) IBOutlet UIView *imageBorderView1;
@property (nonatomic) IBOutlet UIView *imageBorderView2;

@property (nonatomic) IBOutlet UIView *bgView1;
@property (nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView21;
@property (weak, nonatomic) IBOutlet UIView *bgView22;

@property id<MsgHandler> msgHandler;
@property int productId1;
@property int productId2;
- (void)myinit;
@end
