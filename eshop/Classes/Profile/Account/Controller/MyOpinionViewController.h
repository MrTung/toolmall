//
//  MyOpinionViewController.h
//  eshop
//
//  Created by mc on 16/4/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"

#import "OrderService.h"
#import "MyOpinionCell.h"
#import "OpinionViewController.h"

@interface MyOpinionViewController : UIBaseController<ServiceResponselDelegate,UITableViewDataSource,UITableViewDelegate>

{
    OrderService * orderService;
    NSMutableArray * appReviews;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableList;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteOpinion;


@property (nonatomic, strong)  AppOrderInfo * appOrderInfo;
@property (nonatomic, assign)  long sn;

@end
