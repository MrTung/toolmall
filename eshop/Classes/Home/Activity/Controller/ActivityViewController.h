//
//  ActivityViewController.h
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CDVViewController.h"
#import "PullTableView.h"
#import "ActivityService.h"
#import "Response.h"
#import "ListResponse.h"
#import "AppProduct.h"
#import "AppActivity.h"
#import "ActivityCell.h"
#import "ProductInfoViewController.h"
#import "YCXMenu.h"
@interface ActivityViewController : CDVViewController <PullTableViewDelegate,ServiceResponselDelegate>

{
    NSMutableArray * appProducts;
    AppActivity * appActivity;
    ActivityService * activityService;
    Pagination * pagination;
    NSString * mode;
}

@property (strong, nonatomic) IBOutlet PullTableView *tableList;
@property (strong, nonatomic)  EGOImageView *bannerImage; //活动图片
@property (strong, nonatomic)  UIView * viewTextContent; //文本内容包含标题，日期，详情描述
@property (strong, nonatomic)  UILabel *lblTitle; //活动标题
@property (strong, nonatomic)  UILabel *lblDate; //活动日期
@property (strong, nonatomic)  UILabel *lblDesc; //活动详情描述
@property (strong, nonatomic)  UIButton * btnShow; //展开详情描述的按钮
@property (strong, nonatomic)  UILabel *lblShow; //展开详情 四个字
@property (strong, nonatomic)  UIImageView *imgShow; //展开详情的向下小图标

@property (strong, nonatomic)  UIView * tableHead; //表格的头视图
@property (strong, nonatomic)  UIImageView * ima1; //活动详情前面的时间小图标
@property (strong, nonatomic)  UIImageView * ima2; //活动详情前面的内容小图标
@property (assign, nonatomic)  NSInteger activityId;

@property CGFloat headHeight;
@property BOOL isShowed;

@property (strong, nonatomic) NSMutableArray * threeDotItems;

@property (nonatomic, copy) NSString *navTitle;

@end
