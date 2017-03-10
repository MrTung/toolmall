//
//  CatRootListViewController.h
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryService.h"
#import "CatRootCollectionViewCell.h"
#import "CatSecdListViewController.h"

@interface CatRootListViewController : UIBaseController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
    BOOL reloading;
    
    ProductCategoryService * prodCatService;
    NSArray * roots;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (strong, nonatomic) UICollectionView *collectionRootList;

//@property (strong, nonatomic) IBOutlet UITableView *tableRootList;
@property (nonatomic, copy) NSString *type;

@end
