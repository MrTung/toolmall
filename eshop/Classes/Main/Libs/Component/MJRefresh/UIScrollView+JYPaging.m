//
//  UIScrollView+JYPaging.m
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import "MJRefresh.h"
#import "UIScrollView+JYPaging.h"

static float kAnimationDuration = 0.25f;

static const char jy_originContentHeight;
static const char jy_secondScrollView;

@interface UIScrollView()

@property (nonatomic, assign) float originContentHeight;
@end

@implementation UIScrollView (JYPaging)

- (void)setOriginContentHeight:(float)originContentHeight {
    objc_setAssociatedObject(self, &jy_originContentHeight, @(originContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)originContentHeight {
    return [objc_getAssociatedObject(self, &jy_originContentHeight) floatValue];
}


- (void)setFirstScrollView:(UIScrollView *)firstScrollView {
    [self addFirstScrollViewFooter];
}

- (UIScrollView *)secondScrollView {
    return objc_getAssociatedObject(self, &jy_secondScrollView);
}

- (void)setSecondScrollView:(UIScrollView *)secondScrollView {
    objc_setAssociatedObject(self, &jy_secondScrollView, secondScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addFirstScrollViewFooter];
    
    CGRect frame = self.bounds;
    frame.origin.y = self.contentSize.height + self.mj_footer.frame.size.height;
    secondScrollView.frame = frame;
    
    [self addSubview:secondScrollView];
    
    [self addSecondScrollViewHeader];
}

- (void)addFirstScrollViewFooter {
    __weak __typeof(self) weakSelf = self;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf endFooterRefreshing];
    }];
    footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y, footer.frame.size.width, 0);
    footer.backgroundColor = [UIColor redColor];
//    footer.triggerAutomaticallyRefreshPercent = 2;
//    [footer setTitle:@"" forState:MJRefreshStateIdle];
    
    self.mj_footer = footer;
}

- (void)addSecondScrollViewHeader {
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf endHeaderRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉,返回宝贝详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放,返回宝贝详情" forState:MJRefreshStatePulling];
   
    self.secondScrollView.mj_header = header;
}

- (void)endFooterRefreshing {
    [self.mj_footer endRefreshing];
    self.mj_footer.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.mj_header.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height - self.mj_footer.frame.size.height, 0, 0, 0);
    }];
    
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
}

- (void)endHeaderRefreshing {
    [self.secondScrollView.mj_header endRefreshing];
    self.secondScrollView.mj_header.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.mj_footer.hidden = NO;
    self.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, self.mj_footer.frame.size.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
}

@end
