//
//  OpinionViewController.h
//  eshop
//
//  Created by mc on 16/4/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "AppOrderInfo.h"
#import "ReviewService.h"
//#import "SubmitReviewCell.h"
//#import "SubmitReviewFooter.h"
#import "AppOrderItem.h"
#import "OrderList.h"
#import "PullTableView.h"
#import "OpinionCell.h"
@interface OpinionViewController : UIBaseController 
{
    ReviewService *reviewService;
}

@property (strong, nonatomic) IBOutlet UITableView *tableList;

@property (strong, nonatomic) AppOrderInfo * appOrderInfo;
@end
