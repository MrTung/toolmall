//
//  OpinionViewController.m
//  eshop
//
//  Created by mc on 16/4/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "OpinionViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
@interface OpinionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addNavBackButton];
    [self setTextValue];
    // @"发表评价"
    NSString *opinionVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"opinionVC_navItem_title"];
    self.navigationItem.title = opinionVC_navItem_title;
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = opinionVC_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    reviewService = [[ReviewService alloc] initWithDelegate:self parentView:self.view];
    _tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableList.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _tableList.delegate = self;
    _tableList.dataSource = self;
    
    self.heightLayoutConstraint.constant = TMScreenH *40/568;
    
    [_tableList reloadData];
}
- (IBAction)ExpressOpinion:(id)sender {
    NSMutableArray *reviews = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<_appOrderInfo.appOrderItems.count; i++){
        AppOrderItem *orderItem = (AppOrderItem*)[_appOrderInfo.appOrderItems objectAtIndex:i];
        AppReview *review = [[AppReview alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        OpinionCell *cell = [_tableList cellForRowAtIndexPath:indexPath];
        review.score = 1;
        review.content = cell.content.text;
        if (review.content == nil){
            // @"五星好评"
            NSString *opinionVC_review_content = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"opinionVC_review_content"];
            review.content = opinionVC_review_content;
        }
        review.orderItemId = orderItem.id;
        [reviews addObject:review];
    }
    [reviewService submit:reviews isAnonymity:false];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_review_submit]){
        ReviewsResponse *respobj = (ReviewsResponse*)response;
        if (respobj.status.succeed == 1){
            // @"成功评价"
            NSString *opinionVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"opinionVC_toastNotification_msg1"];
            [CommonUtils ToastNotification:opinionVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appOrderInfo.appOrderItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TMScreenH *100/568;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpinionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OpinionCell" owner:self options:nil] lastObject];
//        for (NSObject *o in objects) {
//            if ([o isKindOfClass:[OpinionCell class]]) {
//                cell = (OpinionCell *)o;
//                break;
//            }
//        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AppOrderItem *orderItem = [_appOrderInfo.appOrderItems objectAtIndex:indexPath.row];
    cell.image.imageURL = [URLUtils createURL:orderItem.thumbnail];
    
    return cell;
}

#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 发表评价
    NSString *opinionVC_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"opinionVC_btn_title"];
    [self.btn1 setTitle:opinionVC_btn_title forState:(UIControlStateNormal)];
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
