//
//  MyOpinionViewController.m
//  eshop
//
//  Created by mc on 16/4/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "MyOpinionViewController.h"

@interface MyOpinionViewController ()

@end

@implementation MyOpinionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [super addNavBackButton];
    [super addThreedotButton];
    // @"我的评价"
    NSString *myOpinionVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myOpinionVC_navItem_title"];
    [super addNavTitle:myOpinionVC_navItem_title];
    
    appReviews = [NSMutableArray arrayWithCapacity:10];
//    appReviews = (NSMutableArray *)@[@[@"钳子1",@"用的还不错啊",@"2014-13-12"],@[@"sdfdsf",@"sdfsdf",@"sdfjidisf"],@[@"sdfdsf",@"sdfsdf",@"sdfjidisf"]];
//    self.navigationItem.title = @"我的评价";
//    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    nTitle.text = @"我的评价";
//    nTitle.textAlignment = NSTextAlignmentCenter;
//    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
//    nTitle.font = [UIFont systemFontOfSize:20];
//    self.navigationItem.titleView = nTitle;
//    
    
    [CommonUtils addBorderOnButton:_btnWriteOpinion];
    
    self.tableList.tableFooterView = nil;
    self.tableList.delegate = self;
    self.tableList.dataSource = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    orderService.delegate = self;
    [orderService getOrderOpinionList:_appOrderInfo.id];

}


- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    if ([url isEqualToString:api_review_listoforder]) {
        
        OpinionListResponse * respobj = [[OpinionListResponse alloc] init];
        
        respobj = (OpinionListResponse *)response;
        
        if (respobj.status.succeed) {
            if (respobj.data.count > 0) {
                [appReviews addObjectsFromArray:respobj.data];
                [self.tableList reloadData];
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appReviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyOpinionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOpinionCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyOpinionCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyOpinionCell class]]) {
                cell = (MyOpinionCell *)o;
                break;
            }
        }
        
    }

        AppReview * review = [[AppReview alloc] init];
        review = [appReviews objectAtIndex:indexPath.row];
//        NSLog(@"%@-----", [appReviews objectAtIndex:indexPath.row]);
//        NSLog(@"%@-----",review);
        cell.productImage.imageURL = [URLUtils createURL:review.productImage];
        cell.lblProductName.text = review.productName;
        cell.lblProductOpinion.text = review.content;
        cell.lblProductSpecs.text = [NSString stringWithFormat:@"%@ %@",[CommonUtils formatDate:review.createDate],review.productSpecs];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}

- (IBAction)clickWriteOpinionOnButton:(UIButton *)sender {
    
    OpinionViewController * op = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController" bundle:nil];
    
    op.appOrderInfo = _appOrderInfo;
    [self.navigationController pushViewController:op animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
