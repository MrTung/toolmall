//  HMNewfeatureViewController.h
//
//  Created by 董徐维 on 14-7-7.
//  Copyright (c) 2014年 . All rights reserved.
//

// 是否为4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

#define HMNewfeatureImageCount 3

#import "MTNewfeatureViewController.h"
#import "MTControllerChooseTool.h"

@interface MTNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation MTNewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<HMNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"tuitional_img_%d.jpg", i + 1];
        //        if (FourInch) { // 4inch  需要手动去加载4inch对应的-568h图片
        //            name = [name stringByAppendingString:@"-568h"];
        //        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == HMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(HMNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = TMColor(246, 246, 246);
#warning 别在scrollView.subviews中通过索引来查找对应的子控件
    //    [scrollView.subviews lastObject];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HMNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 30;
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = TMColor(253, 98, 42); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = TMColor(189, 189, 189); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //imageViews:n(add) + 1 + (2 to n-1) + n + 1(add)
    //if scroll to the n(add), goto the n
    //    if (self.scrollView.contentOffset.x == 0) {
    //        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (self.imageViewArray.count - 2), 0);
    //    }
    //if scroll to the 1(add), goto the 1
    //    else if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * (self.imageViewArray.count - 1)) {
    //        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    //    }
    //self.pageControl.currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width - 1;
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景颜色
    [startButton setBackgroundColor:[UIColor redColor]];
    
    // 3.设置frame
    startButton.size = CGSizeMake(80, 40);
    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height * 0.8;
    startButton.titleLabel.font = [UIFont systemFontWithSize:13];
    
    // 4.设置文字
    [startButton setTitle:@"马上体验" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始主页
 */
- (void)start
{
    [MTControllerChooseTool setMainViewController];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}
@end
