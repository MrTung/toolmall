//
//  DetailBrandsVC.h
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailBrandsVC : UIBaseController<EGORefreshTableHeaderDelegate>

{
    EGORefreshTableHeaderView *refreshHeaderView;
    LoadMoreTableFooterView *loadMoreView;
    BOOL reloading;
}

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) int brandId;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property Boolean hasMoreData;

@end

