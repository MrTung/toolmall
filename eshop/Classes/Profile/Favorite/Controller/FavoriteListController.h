//
//  FavoriteListController.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "FavoriteService.h"
#import "FavoriteListResponse.h"
#import "FavoriteList.h"
#import "FavoriteListCell.h"
#import "CartService.h"
#import "Favorite.h"
#import "FootViewItem.h"
#import "ProductService.h"
#import "ProductListResponse.h"
#import "MyProtocols.h"
#import "Pagination.h"
#import "Paginated.h"

@interface FavoriteListController : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate, UIAlertViewDelegate,MsgHandler, PullTableViewDelegate>{
    NSMutableArray * favorites;
  
    NSString *mode;
    NSInteger curDelRow;

}
@property (strong, nonatomic) IBOutlet PullTableView *tableList;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnAddCar;
@property (strong, nonatomic) IBOutlet UIView *btnContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableBtmCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnContainerHeightCons;


@property (nonatomic, strong) UIButton * btnEdit;
@property (nonatomic, strong) UIBarButtonItem * right;
@property NSMutableArray * hotProducts; //用来存储足迹中的item;
@property (nonatomic,strong)  UIScrollView *scrollFoot;
@property (nonatomic,strong)UIView * viewFootprint; //足迹
@end
