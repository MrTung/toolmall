//
//  PaymentMethods.m
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PaymentMethods.h"

@interface PaymentMethods ()

@end

@implementation PaymentMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBackButton];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils setExtraCellLineHidden:self.tableList];
    
    // @"支付方式"
    NSString *paymentMethods_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentMethods_navItem_title"];
    self.navigationItem.title = paymentMethods_navItem_title;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paymentMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPaymentMethod *paymentMethod = [_paymentMethods objectAtIndex:indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentMethodCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaymentMethodCell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.view.frame.size.width, 60)];
        label.text = paymentMethod.name;
        [cell addSubview:label];
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppPaymentMethod *paymentMethod = [_paymentMethods objectAtIndex:indexPath.row];
    NSArray *controllers = [self.navigationController viewControllers];
    OrderController *orderController = (OrderController*)[controllers objectAtIndex:controllers.count - 2];
    [orderController setPaymentMethod:paymentMethod];
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
