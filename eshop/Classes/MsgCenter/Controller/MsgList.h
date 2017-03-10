//
//  MsgList.h
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "MsgService.h"
#import "MsgListResponse.h"
#import "MsgListCell.h"

@interface MsgList : UIBaseController<UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate>{
    MsgService *msgService;
    NSMutableArray *couponCodes;
    Pagination *pagination;
    Boolean footerViewLoaded;
}

@property (nonatomic) IBOutlet PullTableView *tableList;
@property NSMutableArray *msgList;

@end
