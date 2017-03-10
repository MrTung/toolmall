//
//  ProductDetailViewController.m
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "UIFont+Fit.h"

#define  kHeightOfMenu 40


@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//----------------*******------------------//
#pragma  不要动这两行
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _scrollView.contentSize = CGSizeMake(100,200); // 568 + 64 *2
//----------------*******------------------//
    

    _scrollView.backgroundColor = kBGColor;
    _scrollView.delegate = self;
    
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height-40);
    
    _viewMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeightOfMenu)];
    _viewMenu.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_viewMenu];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewMenu.frame), kWidth, 10)];
    viewLine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [_scrollView addSubview:viewLine];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewLine.frame), kWidth, kHeight - kHeightOfMenu - 113)];
//    _webView.scrollView.bounces = NO;
    _webView.backgroundColor = groupTableViewBackgroundColorSelf;
    _webView.delegate = self;
    [_scrollView addSubview:_webView];
    
    float kWidthOfMenuItems = kWidth / 3.0;
    _viewSlider = [[UIView alloc]initWithFrame:CGRectMake(0, kHeightOfMenu-2, kWidthOfMenuItems, 2)];
    _viewSlider.backgroundColor = TMRedColor;
    _viewSlider.tag = 2000;
    [_viewMenu addSubview:_viewSlider];

    
    // @"图文详情"
    NSString *productDetailVC_titleArr_index0 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productDetailVC_titleArr_index0"];
    // @"商品参数"
    NSString *productDetailVC_titleArr_index1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productDetailVC_titleArr_index1"];
    // @"用户评价"
    NSString *productDetailVC_titleArr_index2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productDetailVC_titleArr_index2"];
    NSArray * titleArr = [NSArray arrayWithObjects:productDetailVC_titleArr_index0,productDetailVC_titleArr_index1,productDetailVC_titleArr_index2, nil];
    for(int i=0; i<titleArr.count; i++ ){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWidthOfMenuItems, 0, kWidthOfMenuItems, kHeightOfMenu);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:TMBlackColor forState:UIControlStateNormal];
        [btn setTitleColor:TMBlackColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontWithSize:14];
        btn.tag = 1000+i;
        
        if (i==0) {
            btn.selected = YES;
        }
        
        [_viewMenu addSubview:btn];
    }
//    self.contentSize
}

//按钮的响应方法
-(void)buttonClick:(UIButton *)button
{
    //先取出滑块
    CGPoint center = _viewSlider.center;
    
    //用来去将原来选中的按钮取消掉
    for (UIView * view in self.viewMenu.subviews) {
        if (view.tag != 2000) {
            ((UIButton *)view).selected = NO;
        }
    }
    //将点击的按钮进行选中
    button.selected = YES;
    
    //改变滑块的位置
    center.x = button.center.x;
    
    //使用动画来进行移动改变滑块的位置
    [UIView animateWithDuration:0.3 animations:^{
        //赋给滑块的中心点
        _viewSlider.center = center;
    }];
    

    if (button.tag == 1000) {
//        NSLog(@"商品编号是*****%d",_productId);
        NSString * strurl = [[[api_host stringByAppendingString:api_product_desc] stringByAppendingString:@"?productId="] stringByAppendingString:[NSString stringWithFormat:@"%d", _productId]];
        NSURL *url = [[NSURL alloc] initWithString:strurl];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else if (button.tag == 1001){
//        NSLog(@"跳转到商品参数---%d",_productId);
        NSString * strurl2 = [[[api_host stringByAppendingString:api_product_param] stringByAppendingString:@"?productId="] stringByAppendingString:[NSString stringWithFormat:@"%d", _productId]];
        NSURL *url2 = [[NSURL alloc] initWithString:strurl2];
        [_webView loadRequest:[NSURLRequest requestWithURL:url2]];
        
    }
    else if (button.tag == 1002){
        
//        NSLog(@"跳转到用户评价====%d",_productId);
        NSString * strurl3 = [[[api_host stringByAppendingString:api_review_content] stringByAppendingString:@"?productId="] stringByAppendingString:[NSString stringWithFormat:@"%d", _productId]];
        NSURL *url3 = [[NSURL alloc] initWithString:strurl3];
        [_webView loadRequest:[NSURLRequest requestWithURL:url3]];
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    // @"正在加载"
    NSString *productDetailVC_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productDetailVC_showHUD_title"];
    [CommonUtils showHUD:productDetailVC_showHUD_title andView:self.view andHUD:hud];
    
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    hud.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSLog(@"商品编号是%d",_productId);
    
    NSString * strurl = [[[api_host stringByAppendingString:api_product_desc] stringByAppendingString:@"?os=IOS&productId="] stringByAppendingString:[NSString stringWithFormat:@"%d", _productId]];
    NSURL *url = [[NSURL alloc] initWithString:strurl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y < 0 ) {
//        scrollView.scrollEnabled = NO;
//    }
//}



@end
