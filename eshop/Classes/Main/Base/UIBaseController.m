//
//  UIBaseController.m
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface UIBaseController ()<UIGestureRecognizerDelegate>

@end

@implementation UIBaseController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    MT_Log(@"==%@:%p running method '%@' line %d==", self.class, self, NSStringFromSelector(_cmd),__LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBaseItems];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    
//    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    panGesture.delegate = self; // 设置手势代理，拦截手势触发
//    [self.view addGestureRecognizer:panGesture];
//    
//    // 一定要禁止系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
}


#pragma mark UINavigationControllerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//   
//    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
//    if(self.navigationController.childViewControllers.count == 1)
//    {
//        return NO;
//    }
//    
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavTitle:(NSString *)title{

    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    nTitle.text = title;
    nTitle.textAlignment = NSTextAlignmentCenter;
//    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.textColor = [UIColor darkGrayColor];
    nTitle.font = [UIFont systemFontOfSize:20.0];
    self.navigationItem.titleView = nTitle;
}

- (void)addNavBackButton{
    
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.backgroundColor = [UIColor cyanColor];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [left addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)threedotButtonClick:(UIButton *)button{
    /*
    if (threeDotPopUpViewController == NULL){
        threeDotPopUpViewController = [[ThreeDotPopUpViewController alloc] initWithNibName:@"ThreeDotPopUpViewController" bundle:nil];
        
    }
    if (threedotpopup == NULL){
        threedotpopup = [[STPopupController alloc] initWithRootViewController:threeDotPopUpViewController];
        [threedotpopup setNavigationBarHidden:YES];
        threedotpopup.style = STPopupStyleFormSheet;
    }
    [threedotpopup presentInViewController:self];*/
//    [YCXMenu setTintColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.5]];
    [YCXMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.view.frame.size.width - 70, 56, 70, 0) menuItems:self.threeDotItems selected:^(NSInteger index, YCXMenuItem *item) {
//        NSLog(@"%@",item);
    }];
}


- (void)addBaseItems{
    // set title
    
    // @"首页"
    NSString *baseController_indexMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseController_indexMenu_menuItem"];
    // @"消息"
    NSString *baseController_msgMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseController_msgMenu_menuItem"];

    YCXMenuItem *indexMenu = [YCXMenuItem menuItem:baseController_indexMenu_menuItem image:[UIImage imageNamed:@"threedot_index"]  target:self action:@selector(indexMenuClick:)];
    indexMenu.foreColor = [UIColor whiteColor];
    
    YCXMenuItem *msgMenu = [YCXMenuItem menuItem:baseController_msgMenu_menuItem image:[UIImage imageNamed:@"threedot_msg"]  target:self action:@selector(msgMenuClick:)];
    
    //set item
    self.threeDotItems = [@[indexMenu,
                msgMenu
                ] mutableCopy];
}

- (void)addThreedotMenu:(YCXMenuItem *) menu{
    [self.threeDotItems addObject:menu];
}

- (void)indexMenuClick:(UIButton *)button{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)msgMenuClick:(id)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    
    MsgList *msgList = [[MsgList alloc] initWithNibName:@"MsgList" bundle:nil];
    [self.navigationController pushViewController:msgList animated:YES];
}
- (void)addThreedotButton{
    UIControl * view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.userInteractionEnabled = YES;
//    view.backgroundColor = [UIColor clearColor];

    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 40);
//    right.backgroundColor = [UIColor cyanColor];
    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateHighlighted];
    [right addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
//    [view addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * threedotButtonItem =[[UIBarButtonItem alloc]initWithCustomView:view];
    NSArray<UIBarButtonItem *> *barButtonItems;
    if (self.navigationItem.rightBarButtonItem){
         barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem, self.navigationItem.rightBarButtonItem  , nil];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem , nil];
    }
    self.navigationItem.rightBarButtonItems =barButtonItems;
}

- (void)backButtonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
