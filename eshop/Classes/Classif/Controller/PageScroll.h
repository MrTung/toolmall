//
//  PageScroll.h
//  eshop
//
//  Created by mc on 15-11-9.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollImage.h"
#import "MyAccountViewController.h"
//#import "CatProdList.h"
//#import "Index.h"
#import "CartController.h"
//#import "Test.h"
@interface PageScroll : UIViewController<UIScrollViewDelegate>
{
    BOOL pageControlUsed;
    NSUInteger kNumberOfPages;
    NSMutableArray *images;
}

@property(nonatomic) NSMutableArray* viewControllers;
@property(nonatomic) IBOutlet UIScrollView* scrollView;
@property(nonatomic) IBOutlet UIPageControl* pageControl;

@property (strong, nonatomic) UIWindow *mainWindow;

@end
