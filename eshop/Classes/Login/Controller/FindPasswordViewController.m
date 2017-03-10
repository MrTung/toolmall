//
//  FindPasswordViewController.m
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // @"找回密码"
    NSString *findPasswordVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"findPasswordVC_navItem_title"];
    self.navigationItem.title = findPasswordVC_navItem_title;
    self.webView.backgroundColor = groupTableViewBackgroundColorSelf;
    [self addBaseItems];
    [self addNavBackButton];
    [self addThreedotButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)threedotButtonClick:(UIButton *)button{
    
//    [YCXMenu setTintColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.5]];
    [YCXMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.view.frame.size.width - 70, 56, 70, 0) menuItems:self.threeDotItems selected:^(NSInteger index, YCXMenuItem *item) {
//        NSLog(@"%@",item);
    }];
}


- (void)addBaseItems{
    // set title
    
    // 首页
    NSString *findPasswordVC_indexMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"findPasswordVC_indexMenu_menuItem"];
    // 消息
    NSString *findPasswordVC_msgMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"findPasswordVC_msgMenu_menuItem"];
    
    YCXMenuItem *indexMenu = [YCXMenuItem menuItem:findPasswordVC_indexMenu_menuItem image:[UIImage imageNamed:@"threedot_index"]  target:self action:@selector(indexMenuClick:)];
    indexMenu.foreColor = [UIColor whiteColor];
    
    YCXMenuItem *msgMenu = [YCXMenuItem menuItem:findPasswordVC_msgMenu_menuItem image:[UIImage imageNamed:@"threedot_msg"]  target:self action:@selector(msgMenuClick:)];
    
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
    
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 40);
    //    right.backgroundColor = [UIColor cyanColor];
    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateHighlighted];
    [right addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    [view addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
