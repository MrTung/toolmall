//
//  CatSecdListViewController.h
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppProductCategory.h"
#import "ProductCategoryService.h"
#import "ProdList.h"

@interface CatSecdListViewController : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
    NSArray *secdGradeLists;
    NSArray *thrdGradeLists;
    Boolean isSecdGradeLoad;
    ProductCategoryService * prodCatService;
}

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, copy) NSString *prodCategoryName;
@property (nonatomic, assign) int prodCategoryId;

@end
