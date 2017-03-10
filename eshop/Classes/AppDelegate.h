//
//  AppDelegate.h
//  eshop
//
//  Created by mc on 15/10/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountViewController.h"
#import "CartController.h"
#import "CatRootListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIWindow *scrollWindow;

@property (nonatomic, assign) BOOL showUrl;
@property (nonatomic, copy) NSString *urlStr;

@end

