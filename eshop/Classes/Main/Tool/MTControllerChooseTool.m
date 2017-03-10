//
//  MTControllerChooseTool.m
//
//
//  Created by 董徐维 on 15/8/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTControllerChooseTool.h"
#import "MTNewfeatureViewController.h"


#import "MyAccountViewController.h"
#import "CartController.h"
#import "CatRootListViewController.h"
#import "UIBaseController.h"

@interface MTControllerChooseTool ()<UITabBarControllerDelegate>

@end

@implementation MTControllerChooseTool


+(MTControllerChooseTool *)getInstance
{
    static MTControllerChooseTool *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[MTControllerChooseTool alloc]init];
    });
    return util;
}

+ (void)chooseRootViewController
{
    //如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    //从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    //获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        [MTControllerChooseTool setMainViewController];
        
    } else {
        window.rootViewController = [[MTNewfeatureViewController alloc] init];

        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

+(void)setMainViewController
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES]; //黑色
    
    IndexViewController *indexVC = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
    UINavigationController *indexNav = [[UINavigationController alloc] initWithRootViewController:indexVC];
    [indexNav.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:TMBlackColor}];
    
    CatRootListViewController *catRootListController = [[CatRootListViewController alloc] initWithNibName:@"CatRootListViewController" bundle:nil];
    UINavigationController *catProdListNav = [[UINavigationController alloc] initWithRootViewController:catRootListController];
    
    [catProdListNav.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [catProdListNav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:TMBlackColor}];
    catProdListNav.navigationBarHidden = NO;
    catProdListNav.navigationBar.tintColor = [UIColor whiteColor];
    
    MyAccountViewController *myAccountVC   = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
    UINavigationController * myAccountNav = [[UINavigationController alloc] initWithRootViewController:myAccountVC];
    [catProdListNav.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [myAccountNav.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:TMBlackColor}];
    
    CartController *cartController = [[CartController alloc] initWithNibName:@"CartController" bundle:nil];
    cartController.hasBottomBar = true;
    UINavigationController * cartNav = [[UINavigationController alloc] initWithRootViewController:cartController];
    [cartNav.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [cartNav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:TMBlackColor}];
    cartNav.navigationBarHidden = NO;
    cartNav.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = [MTControllerChooseTool getInstance];
    
    [tabBarController.tabBar setTintColor:[UIColor clearColor]];
    [tabBarController.tabBar setBarTintColor:[UIColor clearColor]];
    
    CGRect frame = CGRectMake(0, 0, TMScreenW, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:@"nav_bgLight"];
    
    UIColor *color = [[UIColor alloc] initWithPatternImage:img];
    v.backgroundColor = color;
    [tabBarController.tabBar insertSubview:v atIndex:0];
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:
                                        indexNav,
                                        catProdListNav,
                                        cartNav,
                                        myAccountNav,
                                        nil];
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    //    修改文本颜色
    for (UITabBarItem * item in tabBar.items) {
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    }
    
    // @"首页"
    NSString *appDelegate_tabBarItem1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"appDelegate_tabBarItem1_title"];
    // @"分类"
    NSString *appDelegate_tabBarItem2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"appDelegate_tabBarItem2_title"];
    // @"购物车"
    NSString *appDelegate_tabBarItem3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"appDelegate_tabBarItem3_title"];
    // @"我的"
    NSString *appDelegate_tabBarItem4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"appDelegate_tabBarItem4_title"];
    
    if (!appDelegate_tabBarItem1_title.length || !appDelegate_tabBarItem2_title.length || !appDelegate_tabBarItem3_title.length || !appDelegate_tabBarItem4_title.length) {
        
        appDelegate_tabBarItem1_title = @"首页";
        appDelegate_tabBarItem2_title = @"分类";
        appDelegate_tabBarItem3_title = @"购物车";
        appDelegate_tabBarItem4_title = @"我的";
    }
    tabBarItem1.title = appDelegate_tabBarItem1_title;
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"首页1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"首页2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem2.title = appDelegate_tabBarItem2_title;
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"分类1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"分类2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem3.title = appDelegate_tabBarItem3_title;
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"购物车1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@" 购物车2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [AppStatic setCART_ITEM_BAR_ITEM:tabBarItem3];
    
    tabBarItem4.title = appDelegate_tabBarItem4_title;
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"我的1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image = [[UIImage imageNamed:@"我的2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //加载用户信息
    if ([SESSION getSession].uid > 0){
        UserInfoService *userInfoService = [[UserInfoService alloc] init];
        [userInfoService getUserInfo];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if (tabBarController.selectedIndex != [tabBarController.viewControllers indexOfObject:viewController])
    {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIBaseController *baseVC = (UIBaseController *)nav.viewControllers[0];
        if ([baseVC respondsToSelector:@selector(refreshData)]) {
            MT_Log(@"刷新数据");
            [baseVC refreshData];
        }
    }

    return YES;
}


@end
