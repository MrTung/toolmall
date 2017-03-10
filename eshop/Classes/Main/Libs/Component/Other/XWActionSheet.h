//
//  PromptView.h
//  ZhuBoJieMian
//
//  Created by 温仲斌 on 15/12/8.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWActionSheet : UIView

@property (nonatomic, copy) void (^idxBlock)(NSInteger idx);

- (id)initWithTitleArray:(NSArray *)titleArray;
- (void)show;
@end
