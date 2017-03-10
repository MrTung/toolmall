//
//  MsgDialogController.h
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgService.h"
#import "PullTableView.h"

@interface MsgDialogController : UIViewController<UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate, ServiceResponselDelegate>{
    MsgService *msgService;
    NSMutableArray *couponCodes;
    Pagination *pagination;
    Boolean footerViewLoaded;
    NSMutableArray *msgList;
}

@property (nonatomic) IBOutlet PullTableView *tableList;
@property (nonatomic) IBOutlet UITextField *sendMsgContent;
@property AppMessage *appMessage;

@end
