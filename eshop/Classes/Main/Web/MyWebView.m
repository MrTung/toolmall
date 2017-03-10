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
//@property (strong,nonatomic)UIWebView *webView;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [CommonUtils showHUD:@"正在加载" andView:self.view andHUD:hud];
    
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
//    hud.hidden = YES;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    //获取当前页面的title
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.currentURL = webView.request.URL.absoluteString;
//    NSString *ns = @"document.documentElement.innerHTML";//获取当前网页的html
//    self.currentHTML = [webView stringByEvaluatingJavaScriptFromString:ns];
//    NSArray *strArr = [self filterImage:self.currentHTML];
//    NSString *imgUrl = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClass(\"propic\");"]];

}
/*
- (NSArray *)filterImage:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}
*/

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
    
    if ([self.type isEqualToString:@"register"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        
#pragma 修改注册协议逻辑<从注册协议页面一直返回至我的页面导航条替换><注释原因>
//        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[ShopLoginViewController class]]) {
//                [temp removeFromParentViewController];
//            }
//        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
