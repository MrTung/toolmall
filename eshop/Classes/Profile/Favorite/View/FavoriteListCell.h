//
//  FavoriteListCell.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProtocols.h"
@interface FavoriteListCell : UITableViewCell

@property (nonatomic) IBOutlet EGOImageView *image1;

@property (nonatomic) IBOutlet UILabel *name1;

@property (nonatomic,weak) IBOutlet UIButton *btn1;

@property (nonatomic,weak) IBOutlet UIButton *control1;

@property (nonatomic,weak) IBOutlet UILabel *lbPrice1;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *cons;

@property (nonatomic,weak) IBOutlet UIView *imageBg1;

@property(nonatomic,weak)  id<MsgHandler> msgHandler;

- (void)myinit;
@end
