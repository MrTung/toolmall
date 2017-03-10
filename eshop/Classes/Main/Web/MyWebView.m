//
//  MyWebView.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "MyWebView.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "ProdList.h"
@interface MyWebView ()
@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;
@end

@implementation MyWebView

@synthesize creatWebView;
@synthesize navTitle;
@synthesize loadUrl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavBackButton];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = navTitle;
    creatWebView.delegate = self;
    
    NSArray *httpArr = [loadUrl componentsSeparatedByString:@"//"];
    loadUrl = [NSString stringWithFormat:@"https://%@", httpArr.lastObject];
    
    NSURL *url = [[NSURL alloc] initWithString:loadUrl];
    [creatWebView loadRequest:[NSURLRequest requestWithURL:url]];
    creatWebView.backgroundColor = groupTableViewBackgroundColorSelf;
    
    
}

- (void)addNavBackButton{
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [left addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@", requestString);
    
    NSArray *strarray = [requestString componentsSeparatedByString:@"keyword="];
    NSArray *strarrayList1 = [requestString componentsSeparatedByString:@"/list/"];
    NSArray *strarrayList2 = @[];
    if (strarrayList1.count==2) {
        strarrayList2 = [strarrayList1[1] componentsSeparatedByString:@".jhtm"];
    }
    //    NSLog(@"%@", strarray);
    //    NSLog(@"strarray0:%@ -- strarray1:%@", strarray[0], strarray[1]);
    
    if ([requestString rangeOfString:@"www.toolmall.com/wap/register.jhtm"].location != NSNotFound) {
        
        RegisteViewController * vc = [[RegisteViewController alloc]initWithNibName:@"RegisteViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        //        IndexViewController *indexVC = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
        //        indexVC.hidesBottomBarWhenPushed = YES;
        //        indexVC.type = @"webView";
        //        [self.navigationController pushViewController:indexVC animated:YES];
        
        return NO;
    }
    else if ([strarray[0] rangeOfString:@"www.toolmall.com/wap/product/search.jhtm"].location != NSNotFound){
        
        ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        prodList.isSearch = true;
        prodList.searchKeyWord = strarray[1];
        [self.navigationController pushViewController:prodList animated:NO];
        
        return NO;
    }
    else if ([strarrayList1[0] rangeOfString:@"www.toolmall.com/wap/product"].location != NSNotFound) {
        
        ProdList * prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        
        if (strarrayList2.count) {
            
            int refID = [strarrayList2[0] intValue];
            prodList.productCategoryId = refID;
            
            [self.navigationController pushViewController:prodList animated:YES];
        }
        return NO;
    }
    else {
        
        return YES;
    }
}

- (void)backButtonClick:(UIButton *)button{
    
    if ([self.type isEqualToString:@"register"])
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
