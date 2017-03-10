//
//  FootPrintViewController.h
//  eshop
//
//  Created by mc on 16/5/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "ProductService.h"
#import "ProductViewHistoryResponse.h"
#import "FootPrintCell.h"
#import "AppBrand.h"
#import "CartService.h"
#import "ProductInfoViewController.h"
#import "Paginated.h"

@interface FootPrintViewController : UIBaseController<ServiceResponselDelegate,PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    Pagination * pagination;
    NSMutableArray * appProducts;
    ProductService * productService;
    CartService * cartService;
}

@property (weak, nonatomic) IBOutlet PullTableView *tableList;


@end
