//
//  UIBaseController.h
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPopupController.h"
#import "YCXMenu.h"
#import "ImageUtils.h"
#import "PBAlertController.h"

@interface UIBaseController : UIViewController{
       
}
@property (strong, nonatomic) NSMutableArray * threeDotItems;

@property (nonatomic, assign) BOOL isRefreshData;
- (void)addNavBackButton;
- (void)addThreedotButton;
- (void)addThreedotMenu:(YCXMenuItem *) menu;
- (void)backButtonClick:(UIButton *)button;
- (void)addNavTitle:(NSString *)title;


-(void)refreshData;

@end
