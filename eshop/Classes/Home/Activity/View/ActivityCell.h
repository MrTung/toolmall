//
//  ActivityCell.h
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppProduct.h"

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBG1;
@property (strong, nonatomic) IBOutlet EGOImageView *image1;
@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *oldPrice1;
@property (strong, nonatomic) IBOutlet UIButton *btnTouch1;
@property (weak, nonatomic) IBOutlet UIImageView *hotImg1;
@property (weak, nonatomic) IBOutlet UIView *cutView1;

@property (weak, nonatomic) IBOutlet UIView *viewBG2;
@property (strong, nonatomic) IBOutlet EGOImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UILabel *price2;
@property (strong, nonatomic) IBOutlet UILabel *oldPrice2;
@property (strong, nonatomic) IBOutlet UIButton *btnTouch2;
@property (weak, nonatomic) IBOutlet UIImageView *hotImg2;
@property (weak, nonatomic) IBOutlet UIView *cutView2;


-(void)setItem:(AppProduct *)productItem row:(NSInteger)row appProducts:(NSMutableArray*)appProducts;
@end
