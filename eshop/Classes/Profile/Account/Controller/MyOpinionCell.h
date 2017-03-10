//
//  MyOpinionCell.h
//  eshop
//
//  Created by mc on 16/4/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface MyOpinionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (weak, nonatomic) IBOutlet UILabel *lblProductOpinion;

@property (weak, nonatomic) IBOutlet UILabel *lblProductSpecs; //产品规格

@end
