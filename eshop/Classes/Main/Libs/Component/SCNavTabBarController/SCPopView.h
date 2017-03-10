//
//  SCPopView.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCPopViewDelegate <NSObject>

@optional
- (void)viewHeight:(CGFloat)height;
- (void)itemPressedWithIndex:(NSInteger)index;

@end

@interface SCPopView : UIScrollView

@property (nonatomic, weak)     id      <SCPopViewDelegate>popDelegate;
@property (nonatomic, strong)   NSArray *itemNames;
@property (nonatomic, strong)   UIFont  *titleFont;

@property (nonatomic, assign)   NSInteger   currentItemIndex;           // current selected item's index

@end
