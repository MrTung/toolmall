//
//  TwoViewController.h
//  图片处理
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFTextField.h"
#import "OrderSearchHistoryItem.h"
#import "OrderService.h"
#import "ListResponse.h"
#import "StatusResponse.h"


@class OrderList;
@interface OrderSearchViewController : UIBaseController<UITextFieldDelegate,ServiceResponselDelegate,UITableViewDataSource,UITableViewDelegate>
{
    OrderService * orderService;
    Pagination * pagination;
}
@property UIButton * btnLeft;
@property UIButton * btnR1;
@property UIButton * btnR2;
@property UITextField * txtSearch;


@property NSMutableArray * sourceArray;
@property (strong, nonatomic) IBOutlet UIView *viewSearchHeader;
@property UIButton *btnClearSearchHistory;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (nonatomic, copy) void (^returnKeyword)(NSString *);
@property (nonatomic, retain) OrderList * orderlist;

@property (nonatomic, strong) UITableView * tableview;


@end
