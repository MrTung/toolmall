//
//  ProdImageScroll.h
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdImageScrollImage.h"

@interface ProdImageScroll : UIBaseController<UIScrollViewDelegate>{
    BOOL pageControlUsed;
    NSUInteger kNumberOfPages;
    NSMutableArray *images;

}
@property(nonatomic) NSMutableArray* viewControllers;
@property(nonatomic) IBOutlet UIScrollView* scrollView;
@property(nonatomic) IBOutlet UIPageControl* pageControl;
@property NSArray *prodImages;
@end
