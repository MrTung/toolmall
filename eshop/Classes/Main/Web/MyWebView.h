//
//  MyWebView.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebView : UIBaseController<UIWebViewDelegate, MBProgressHUDDelegate>{
    MBProgressHUD * hud;
}

@property (nonatomic) IBOutlet UIWebView *creatWebView;
@property NSString *navTitle;
@property NSString *loadUrl;
@property NSString *type;

@end
