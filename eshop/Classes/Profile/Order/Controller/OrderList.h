//
//  OrderList.h
//  toolmall
//
//  Created by mc on 15/10/12.
//


#import <UIKit/UIKit.h>
#import "OrderService.h"
#import "Pagination.h"
#import "Paginated.h"
#import "OrderListCell.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "OrderListItemHeader.h"
#import "OrderListItemFooter.h"
#import "CancelOrder.h"
#import "STPopupController.h"
#import "PullTableView.h"
//#import "SubmitReview.h"
#import "PaymentPlugins.h"
#import "PaymentInfo.h"
//订单搜索页
#import "OrderSearchViewController.h"
#import "ProductCategoryListResponse.h"
#import "ProductService.h"

#import "FootViewItem.h"
#import "LXFTextField.h"
#import "OrderSearchHistoryItem.h"
#import "OrderService.h"
#import "ListResponse.h"
#import "StatusResponse.h"
#import "IndexViewController.h"
#import "MyOpinionViewController.h"
#import "FootPrintViewController.h"

@interface OrderList : UIBaseController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate, UITabBarControllerDelegate,UIAlertViewDelegate,OrderListItemFooterDelegate, CancelOrderDelegate>{
    NSMutableArray * orders;
    OrderService * orderService;
    AppOrderInfo *curOperaterOrder;
    STPopupController *popupController;
    NSArray *filterTypes;
    Pagination * pagination;
    ProductService * productService;

}

@property (nonatomic, strong) NSString * keyword;

@property (strong, nonatomic) IBOutlet PullTableView *tableOrderList;
@property NSString *type;
@property NSString *iniType;

@property (nonatomic, strong) UIButton * btnLeft;
@property (nonatomic, strong) UIButton * btnR1;
@property (nonatomic) IBOutlet UIButton *btnAll;
@property (nonatomic) IBOutlet UIButton *btnAwaitPay;
@property (nonatomic) IBOutlet UIButton *btnAwaitShip;
@property (nonatomic) IBOutlet UIButton *btnShipped;
@property (nonatomic) IBOutlet UIButton *btnAwaitReview;
@property (nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableListTopCons;

@property UIView * viewFootprint; //足迹
@property UIScrollView * scrollFoot;
@property NSMutableArray * arrayFootprint; //用来存储足迹中的item;
@property BOOL footIsExist;

- (void) loadData:(BOOL)refresh;
@end
