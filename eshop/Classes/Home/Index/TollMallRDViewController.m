//
//  TollMallRDViewController.m
//  eshop
//
//  Created by sh on 16/10/31.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "TollMallRDViewController.h"

#import "RecommendDetailView.h"

@interface TollMallRDViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *dataArr;

@end

@implementation TollMallRDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    // 猫工推荐
    NSString *tollMallRDVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"tollMallRDVC_navItem_title"];
    
    [super addNavTitle:tollMallRDVC_navItem_title];
    [super addNavBackButton];
    [super addThreedotButton];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [AppStatic SCREEN_WIDTH],[AppStatic SCREEN_HEIGHT]-64)];
    self.scrollView.backgroundColor = groupTableViewBackgroundColorSelf;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.dataArr = [[TextDataBase shareTextDataBase] getAppIndexUrlNSMutableArray];
    if (self.dataArr.count) {
        
        [self createUI];
    }
    [self.view addSubview:self.scrollView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)createUI {
    
//    float k = 6;
    CGFloat itemSize = [AppStatic SCREEN_WIDTH]/2.0;
    CGFloat totalHeight = 0.0;
    for (int i =0; i < self.dataArr.count-1; i++) {
        NSInteger count = i/2;
        if (i % 2 == 1) {
            count +=1;
        }
        RecommendDetailView * item = [[[NSBundle mainBundle] loadNibNamed:@"RecommendDetailView" owner:self options:nil] firstObject];
        
        //        x 恒 0 即 左边一列
        if (i%2 == 0) {
            item.frame = CGRectMake(0, count*itemSize, itemSize, itemSize);
        }
        //        x 恒 k + ([AppStatic SCREEN_WIDTH] - 4*k)/ 2.0 + 2*k
        //        即 右边一列
        if (i%2 == 1) {
            item.frame = CGRectMake(itemSize, (count-1)*itemSize, itemSize, itemSize);
        }
        item.titleLabel.text = [_dataArr[i] valueForKey:@"conesc"];
        item.contentLabel.text = [_dataArr[i] valueForKey:@"coness"];
//        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_dataArr[i] valueForKey:@"newimage"]]];
//        item.imageView.image = [UIImage imageWithData:imgData];
        item.imageView.imageURL = [URLUtils createURL:[_dataArr[i] valueForKey:@"newimage"]];
        [self.scrollView addSubview:item];
        
        item.recommendBtn.tag = 1000+i;
        [item.recommendBtn addTarget:self action:@selector(clickToolMallDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        totalHeight = (i/2+1) * itemSize;
    }
    if ((self.dataArr.count-1)%2 == 1) {
        
        UIView *backWhiteView = [[UIView alloc] initWithFrame:(CGRectMake(itemSize, totalHeight-itemSize, itemSize, itemSize-0.5))];
        backWhiteView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:backWhiteView];
        
    }
    //  重写给scrollview滚动范围赋值
    self.scrollView.contentSize = CGSizeMake([AppStatic SCREEN_WIDTH], totalHeight);
}

- (void)clickToolMallDetailVC:(UIButton *)sender {
    
    if (self.dataArr.count) {
        
        int i = sender.tag-1000;
        AppIndexUrl *appIndexUrl = self.dataArr[i];
        ActivityViewController * p = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
//        p.navTitle = appIndexUrl.title;
        p.activityId = appIndexUrl.refId;
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p  animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
