//
//  PageScroll.m
//  eshop
//
//  Created by mc on 15-11-9.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "PageScroll.h"

#import "UIFont+Fit.h"

@interface PageScroll ()

@end

@implementation PageScroll

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    images = [[NSMutableArray alloc] initWithCapacity:3];
    [images addObject:@"tuitional_img_1.jpg"];
    [images addObject:@"tuitional_img_3.jpg"];
    [images addObject:@"tuitional_img_2.jpg"];
    [images addObject:@"tuitional_img_2"];
    kNumberOfPages =4;
    
    NSMutableArray* controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0 ; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake([AppStatic SCREEN_WIDTH]*kNumberOfPages, [AppStatic SCREEN_HEIGHT]);
    //  self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.pageControl.numberOfPages = kNumberOfPages;
    self.pageControl.currentPage = 0;
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollViewWithPage:0];
//    [self loadScrollViewWithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) changePage:(id)sender{
    int page = self.pageControl.currentPage;
//    NSLog(@"chanepage page=%d",page);
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width*page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


-(void) loadScrollViewWithPage:(int)page{
    if (page < 0) {
        return;
    }else if(page >= kNumberOfPages) {
        //do some thing,like jump to other screen
        
        [self.mainWindow makeKeyAndVisible];
        [[Config Instance] saveUserInfo:@"firstUse" withvalue:@"N"];
        return;
    }
    
    PageScrollImage * controller = [self.viewControllers objectAtIndex:page];
  if ((NSNull*)controller == [NSNull null]) {
        controller = [[PageScrollImage alloc] init];
        if (page == kNumberOfPages - 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 40, self.view.frame.size.height - 100, 80, 40)];
            [button setTitle:@"马上体验" forState:UIControlStateNormal];
            button.font = [UIFont systemFontWithSize:13];
            [button setBackgroundColor:[AppStatic APP_RED_COLOR] ];
            [button addTarget:self action:@selector(startApp:) forControlEvents:UIControlEventTouchUpInside];
            [controller.view addSubview:button];
        }
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        
        controller.image.image = [UIImage imageNamed:[images objectAtIndex:page]];
    }
}

-(IBAction)startApp:(id)sender{
    [self.mainWindow makeKeyAndVisible];
    [[Config Instance] saveUserInfo:@"firstUse" withvalue:@"N"];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //page表示当前滚动哪一页的标识
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
    
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


@end
