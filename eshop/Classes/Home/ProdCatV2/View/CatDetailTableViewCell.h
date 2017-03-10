//
//  CatDetailTableViewCell.h
//  eshop
//
//  Created by sh on 16/10/8.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatSecdListViewController;

@class AppProductCategory;
@protocol TypeSeleteDelegete <NSObject>

-(void)btnindex:(NSInteger)tag row:(NSInteger)row;

@end


@interface CatDetailTableViewCell : UITableViewCell

@property (nonatomic) CatSecdListViewController *owner;

@property (nonatomic, retain) UILabel *lab;
@property (nonatomic, retain) UILabel *line;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, assign)float height;
@property (nonatomic, assign)int seletIndex;

@property (nonatomic, strong) AppProductCategory *model;
@property (nonatomic, weak) id<TypeSeleteDelegete> delegate;

+ (CGFloat)initWithdatasource:(AppProductCategory *)model;

+(instancetype)createCellWithTableView:(UITableView *)tableview;

@end
