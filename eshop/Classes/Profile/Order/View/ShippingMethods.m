//
//  ShippingMethods.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "ShippingMethods.h"

@interface ShippingMethods ()

@end

@implementation ShippingMethods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBackButton];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils setExtraCellLineHidden:self.tableShippingMethods];
    
    // @"配送方式"
    NSString *shippingMethods_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shippingMethods_navItem_title"];
    self.navigationItem.title = shippingMethods_navItem_title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shippingMethods.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppShippingMethod *shippingMethod = [_shippingMethods objectAtIndex:indexPath.row];
    ShippingMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShippingMethodCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ShippingMethodCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ShippingMethodCell class]]) {
                cell = (ShippingMethodCell *)o;
                break;
            }
        }
    }
    [cell.name setText:shippingMethod.name];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppShippingMethod *shippingMethod = [_shippingMethods objectAtIndex:indexPath.row];
    NSArray *controllers = [self.navigationController viewControllers];
    OrderController *orderController = (OrderController*)[controllers objectAtIndex:controllers.count - 2];
    [orderController setShippingMethod:_section shippingMethod:shippingMethod];
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
