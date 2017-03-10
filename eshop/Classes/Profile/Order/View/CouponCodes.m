//
//  CouponCodes.m
//  eshop
//
//  Created by mc on 15/11/9.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CouponCodes.h"

@interface CouponCodes ()

@end

@implementation CouponCodes

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBackButton];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils setExtraCellLineHidden:self.tableList];
    
    // @"优惠券"
    NSString *couponCodes_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodes_navItem_title"];
    // @"没有结果"
    NSString *couponCodes_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodes_noResultView_desc"];
    self.navigationItem.title = couponCodes_navItem_title;
    if (_couponCodes.count > 0){
        [self.tableList reloadData];
    } else {
//        [CommonUtils displayNoResultView:self.view];
        [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:couponCodes_noResultView_desc];
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
//        [CommonUtils displayNoResultView:self.view frame:self.view.frame];
        
        self.tableList.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppCouponCode *couponCode = [_couponCodes objectAtIndex:indexPath.row];
    CouponCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCodeCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CouponCodeCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[CouponCodeCell class]]) {
                cell = (CouponCodeCell *)o;
                break;
            }
        }
    }
    [cell.name setText:couponCode.coupon.name];
    cell.image.imageURL = [NSURL URLWithString:couponCode.coupon.image];
    cell.beginDate.text = [CommonUtils formatDate:couponCode.coupon.beginDate];
    cell.endDate.text = [CommonUtils formatDate:couponCode.coupon.endDate];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppCouponCode *couponCode = [_couponCodes objectAtIndex:indexPath.row];
    NSArray *controllers = [self.navigationController viewControllers];
    OrderController *orderController = (OrderController*)[controllers objectAtIndex:controllers.count - 2];
    [orderController setCouponCode:_section couponCode:couponCode];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
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
