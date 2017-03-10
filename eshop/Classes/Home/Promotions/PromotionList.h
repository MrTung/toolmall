//
//  PromotionList.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionListResponse.h"
#import "PromotionService.h"
#import "PullTableView.h"
#import "PromotionListCell.h"
#import "ProdList.h"

@interface PromotionList : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *promotions;
    PromotionService *promotionService;
    Pagination *pagination;
}
@property (nonatomic) IBOutlet PullTableView *tableList;
@end
