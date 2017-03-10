//
//  SCPopView.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCPopView.h"
#import "CommonMacro.h"

@implementation SCPopView

#pragma mark - Private Methods
#pragma mark -
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles) {
        CGSize size = [title sizeWithAttributes:
                       @{NSFontAttributeName: _titleFont}];
        CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        NSNumber *width = [NSNumber numberWithFloat:adjustedSize.width + 20.0f];
        [widths addObject:width];
    }
    
    return widths;
}

- (void)updateSubViewsWithItemWidths:(NSArray *)itemWidths;
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    self.userInteractionEnabled = YES;
    CGFloat marginX = kWidth *10/320;
    CGFloat marginY = kWidth *10/320;
    CGFloat buttonH = kHeight *25/568;
    CGFloat buttonX = marginX;
    CGFloat buttonY = marginY;
    for (NSInteger index = 0; index < [itemWidths count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(buttonX, buttonY, [itemWidths[index] floatValue], buttonH);
        [button setTitle:_itemNames[index] forState:UIControlStateNormal];
        button.titleLabel.font = _titleFont;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        button.layer.cornerRadius=3;
        button.layer.masksToBounds=YES;
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        
        if (index == _currentItemIndex) {
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setBackgroundColor:redColorSelf];
        }
        
//        NSLog(@"\n self.frame: %@ - button.frame: %@ \n", NSStringFromCGRect(self.frame), NSStringFromCGRect(button.frame));
        buttonX += ([itemWidths[index] floatValue] + marginX);
        
        @try {
            if ((buttonX + [itemWidths[index + 1] floatValue] + marginX) >= SCREEN_WIDTH)
            {
                buttonX = marginX;
                buttonY += (buttonH + marginY);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
//        NSLog(@"\n Height: %f - %f \n", buttonX, buttonY);
    }
}

- (void)itemPressed:(UIButton *)button
{
    [_popDelegate itemPressedWithIndex:button.tag];
}

#pragma mark - Public Methods
#pragma marl -
- (void)setItemNames:(NSArray *)itemNames
{
    _itemNames = itemNames;
    
    NSArray *itemWidths = [self getButtonsWidthWithTitles:itemNames];
    [self updateSubViewsWithItemWidths:itemWidths];
}

@end
