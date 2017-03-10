//
//  CatDetailTableViewCell.m
//  eshop
//
//  Created by sh on 16/10/8.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CatDetailTableViewCell.h"

#import "UIFont+Fit.h"
#import "AppProductCategory.h"
#import "CatSecdListViewController.h"
@interface CatDetailTableViewCell ()


@end

@implementation CatDetailTableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableview
{
    static NSString *cellId = @"CatDetailTableViewCell";
    CatDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CatDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = groupTableViewBackgroundColorSelf;
    }
    
    return cell;
}


+ (CGFloat)initWithdatasource:(AppProductCategory *)model {

    BOOL  isLineReturn = NO;
    float upX = TMScreenW *10/320;
    float upY = TMScreenH *40/568;
    
    for (int i = 0; i < model.children.count; i++) {
        
        AppProductCategory *thirdModle = [model.children objectAtIndex:i] ;
        
        NSString *strName = thirdModle.name;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontWithSize:12] forKey:NSFontAttributeName];
        CGSize size = [strName sizeWithAttributes:dic];
        
        int sizeWidth = floor(size.width);
        
        if ( upX > (TMScreenW- TMScreenW *20/320 - sizeWidth- TMScreenW *15/320)) {
            
            isLineReturn = YES;
            upX = TMScreenW *10/320;
            upY += TMScreenH *30/568;;
        }
        
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(upX, upY, sizeWidth+ TMScreenW *15/320, TMScreenH *25/568);
        btn.titleLabel.font = [UIFont systemFontWithSize:12];
        [btn setTitle:strName forState:0];
        upX+=sizeWidth+ TMScreenW *20/320;
    }
    
    return upY+ TMScreenH *35/568;
}

- (void)setModel:(AppProductCategory *)model {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontWithSize:14] forKey:NSFontAttributeName];
    CGSize labSize = [model.name sizeWithAttributes:dic];
    
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *15/320, TMScreenH *10/568, labSize.width, TMScreenH *20/568)];
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lab.frame)+ TMScreenW *10/320, TMScreenH *20/568, TMScreenW-CGRectGetMaxX(self.lab.frame)- TMScreenW *20/320, 0.3)];
    
    _lab.text = model.name;
    _lab.textColor = [UIColor blackColor];
    _lab.font = [UIFont systemFontWithSize:14];
    [self addSubview:_lab];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line];
    
    BOOL  isLineReturn = NO;
    float upX = TMScreenW *10/320;
    float upY = TMScreenH *40/568;
    
    for (int i = 0; i < model.children.count; i++) {
        
        AppProductCategory *thirdModle = [model.children objectAtIndex:i] ;
        
        NSString *strName = thirdModle.name;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontWithSize:12] forKey:NSFontAttributeName];
        CGSize size = [strName sizeWithAttributes:dic];
        
        int sizeWidth = floor(size.width);
        
        //NSLog(@"%f",size.height);
        if ( upX > (TMScreenW- TMScreenW *20/320 - sizeWidth- TMScreenW *15/320)) {
            
            isLineReturn = YES;
            upX = TMScreenW *10/320;
            upY += TMScreenH *30/568;
        }
        
        self.btn= [UIButton buttonWithType:UIButtonTypeSystem];
        _btn.frame = CGRectMake(upX, upY, sizeWidth+ TMScreenW *15/320,TMScreenH *25/568);
//        [_btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [_btn setBackgroundColor:[UIColor whiteColor]];
        [_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        _btn.titleLabel.font = [UIFont systemFontWithSize:12];
//        AppProductCategory *thirdModle = [model.children objectAtIndex:i];
        [_btn setTitle:strName forState:UIControlStateNormal];
        _btn.layer.cornerRadius = 3;
        _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btn.layer.borderWidth = 0.5;
        [_btn.layer setMasksToBounds:YES];
        
        CGPoint pointCenter = _btn.center;
        int center_x = floor(pointCenter.x);
        int center_y = floor(pointCenter.y);
        _btn.center = CGPointMake(center_x, center_y);
        
        [self addSubview:_btn];
        _btn.tag = 100+i;
        [_btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
        upX+=sizeWidth+ TMScreenW *20/320;
    }
    
//    self.height = upY+11;
    
    self.seletIndex = -1;
}


-(void)touchbtn:(UIButton *)btn
{
    NSIndexPath *cellPath = [self.owner.tableView indexPathForCell:self];
    [self.delegate btnindex:btn.tag-100 row:cellPath.row];
}


@end
