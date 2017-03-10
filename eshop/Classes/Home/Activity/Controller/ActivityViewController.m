//
//  ActivityViewController.m
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat descHeight;
}
@end

@implementation ActivityViewController

- (void)addNavTitle{
    // @"专题活动"
    NSString *activityVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_navItem_title"];
    
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = self.navTitle;
    if (!self.navTitle.length) {
        nTitle.text = activityVC_navItem_title;
    }
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor darkGrayColor];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
}

- (void)addNavBackButton{
    
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [left addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)backButtonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addThreedotButton{
    
    UIControl * view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.userInteractionEnabled = YES;
    
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 40);
    //    right.backgroundColor = [UIColor cyanColor];
    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateNormal];
//    [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateHighlighted];
    [right addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view  addSubview:right];
    [view addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * threedotButtonItem =[[UIBarButtonItem alloc]initWithCustomView:view];
    NSArray<UIBarButtonItem *> *barButtonItems;
    if (self.navigationItem.rightBarButtonItem){
        barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem, self.navigationItem.rightBarButtonItem  , nil];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem , nil];
    }
    self.navigationItem.rightBarButtonItems =barButtonItems;
}

- (void)threedotButtonClick:(UIButton *)button{
//    [YCXMenu setTintColor:[UIColor colorWithRed:41 / 255.0 green:46 / 255.0 blue:49 / 255.0 alpha:1]];
//    [YCXMenu setTintColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.5]];
    [YCXMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.view.frame.size.width - 70, 56, 70, 0) menuItems:self.threeDotItems selected:^(NSInteger index, YCXMenuItem *item) {
//        NSLog(@"%@",item);           
    }];
}

- (void)addBaseItems{
    
    // @"首页"
    NSString *activityVC_indexMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_indexMenu_menuItem"];
    // @"消息"
    NSString *activityVC_msgMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_msgMenu_menuItem"];
    YCXMenuItem *indexMenu = [YCXMenuItem menuItem:activityVC_indexMenu_menuItem image:[UIImage imageNamed:@"threedot_index"]  target:self action:@selector(indexMenuClick:)];
    indexMenu.foreColor = [UIColor whiteColor];
    
    YCXMenuItem *msgMenu = [YCXMenuItem menuItem:activityVC_msgMenu_menuItem image:[UIImage imageNamed:@"threedot_msg"]  target:self action:@selector(msgMenuClick:)];
    
    //set item
    self.threeDotItems = [@[indexMenu,
                            msgMenu
                            ] mutableCopy];
}

- (void)addThreedotMenu:(YCXMenuItem *) menu{
    [self.threeDotItems addObject:menu];
}

- (void)indexMenuClick:(UIButton *)button{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)msgMenuClick:(id)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    MsgList *msgList = [[MsgList alloc] initWithNibName:@"MsgList" bundle:nil];
    [self.navigationController pushViewController:msgList animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBaseItems];
    
    [self addNavBackButton];
    
    [self addNavTitle];
    
    [self addThreedotButton];
    
    descHeight = TMScreenH *60/568;
    _headHeight = 0;
    _isShowed = NO;

    pagination = [[Pagination alloc] init];
    pagination.page = 1;
    appProducts = [[NSMutableArray alloc] initWithCapacity:20];
    appActivity = [[AppActivity alloc] init];
    _tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableList.delegate = self;
    _tableList.dataSource = self;
    _tableList.pullDelegate = self;

    [self createUI];
    
    activityService = [[ActivityService alloc] initWithDelegate:self parentView:self.view];
    [activityService getActivityInfoWithId:_activityId];
}

- (void)createUI{
    
    _tableHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH *100/568)];
    _tableHead.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0];
    _tableHead.userInteractionEnabled = YES;
    
    _tableList.tableHeaderView = _tableHead;
    _tableList.tableFooterView = nil;
    
    _bannerImage = [[EGOImageView alloc] initWithPlaceholderImage:nil];
    _bannerImage.frame = CGRectMake(0, 0, TMScreenW, TMScreenH *95/568);
    [_tableHead addSubview:_bannerImage];
    
    _viewTextContent = [[UIView alloc] init];
    _viewTextContent.backgroundColor = [UIColor whiteColor];
    _viewTextContent.frame = CGRectMake(0, CGRectGetMaxY(_bannerImage.frame), TMScreenW, TMScreenH *60/568);
    [_tableHead addSubview:_viewTextContent];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *20/320, 5, _viewTextContent.frame.size.width - TMScreenW *40/320, TMScreenH *30/568)];
    _lblTitle.textColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1];
    _lblTitle.text = @"title";
    [_viewTextContent addSubview:_lblTitle];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lblTitle.frame) +1, _viewTextContent.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_viewTextContent addSubview:line];
    
    _ima1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_time"]];
    _ima1.frame = CGRectMake( TMScreenW *20/320,  TMScreenH *10/568 + CGRectGetMaxY(_lblTitle.frame),  TMScreenW *10/320,  TMScreenW *10/320);
    [_viewTextContent addSubview:_ima1];
    
    _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ima1.frame) +  TMScreenW *5/320, CGRectGetMaxY(_lblTitle.frame)+  TMScreenH *5/568, TMScreenW -  TMScreenW *50/320,  TMScreenH *20/568)];
    _lblDate.font = [UIFont systemFontWithSize:11];
    _lblDate.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    [_viewTextContent addSubview:_lblDate];
    
    _ima2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_intro"]];
    _ima2.frame = CGRectMake( TMScreenW *20/320, CGRectGetMaxY(_ima1.frame) + TMScreenH *10/568, TMScreenW *10/320, TMScreenW *10/320);
    [_viewTextContent addSubview:_ima2];
    
    // @"活动介绍:"
    NSString *activityVC_viewTextContent_lblDesc1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblDesc1"];
    // @"展开详情"
    NSString *activityVC_viewTextContent_lblShow1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblShow1"];
    
    _lblDesc = [[UILabel alloc] init];
    _lblDesc.frame = CGRectMake(CGRectGetMaxX(_ima2.frame) + TMScreenW *5/320, CGRectGetMinY(_ima2.frame)- TMScreenH *3/568, TMScreenW -TMScreenW *70/320, descHeight);
    _lblDesc.text = activityVC_viewTextContent_lblDesc1;
    _lblDesc.numberOfLines = 0;
    _lblDesc.font = [UIFont systemFontWithSize:11];
    _lblDesc.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    [_viewTextContent addSubview:_lblDesc];
    
    _viewTextContent.frame = CGRectMake(0, CGRectGetMaxY(_bannerImage.frame), TMScreenW, CGRectGetHeight(_lblTitle.frame) + CGRectGetHeight(_lblDate.frame) + CGRectGetHeight(_lblDesc.frame));
    
//    展开详情模块
    _btnShow = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnShow.backgroundColor = [UIColor whiteColor];
    _btnShow.frame = CGRectMake(0,  CGRectGetMinY(_viewTextContent.frame) + CGRectGetMaxY(_lblDate.frame) + TMScreenH *35/568,    _viewTextContent.frame.size.width, TMScreenH *30/568);
    [_btnShow addTarget:self action:@selector(showActivityDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHead addSubview:_btnShow];
    
    UIView * line2 = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, _btnShow.frame.size.width, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [_btnShow addSubview:line2];
    _lblShow = [[UILabel alloc] initWithFrame:CGRectMake(_btnShow.frame.size.width/2.0 - TMScreenW *30/320, TMScreenH *2/568, TMScreenW *60/320, TMScreenH *26/568)];
    _lblShow.text = activityVC_viewTextContent_lblShow1;
    _lblShow.font = [UIFont systemFontWithSize:10];
    _lblShow.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    [_btnShow addSubview:_lblShow];
    _imgShow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newdown"]];
    _imgShow.frame = CGRectMake(CGRectGetMinX(_lblShow.frame) - TMScreenW *15/320, TMScreenH *10/568, TMScreenW *10/320, TMScreenW *10/320);
    [_btnShow addSubview:_imgShow];
    
    _tableHead.frame = CGRectMake(0, 0, TMScreenW, CGRectGetMinY(_viewTextContent.frame) + CGRectGetHeight(_lblDate.frame) + CGRectGetHeight(_lblDesc.frame)+10 + CGRectGetHeight(_btnShow.frame));
}

//配置活动信息
- (void)configActivityInfo:(AppActivity *)a{
    
//    a.bannerImage = nil;
    if (a.bannerImage) {
        _bannerImage.imageURL = [URLUtils createURL:a.bannerImage];
        _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _viewTextContent.frame.size.height);
    }else{
        [_bannerImage removeFromSuperview];
        _bannerImage = nil;
        _viewTextContent.frame = CGRectMake(0, 0, _viewTextContent.frame.size.width, _viewTextContent.frame.size.height);
    }
    _lblTitle.text = a.title;
    
    _headHeight = CGRectGetMinY(_viewTextContent.frame);
//  用来测试
//    a.beginDate = nil;
//    a.endDate = nil;
    if (a.beginDate != nil || a.endDate !=nil) {
        
        // @"活动时间: %@-%@"
        NSString *activityVC_viewTextContent_lblDate = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblDate"];
        _lblDate.text = [NSString stringWithFormat:activityVC_viewTextContent_lblDate,[self changeDateForm:[CommonUtils formatDate:a.beginDate]],[self changeDateForm:[CommonUtils formatDate:a.endDate]]];
        
        _headHeight = _headHeight + CGRectGetHeight(_lblTitle.frame) + CGRectGetHeight(_lblDate.frame);
    }
    
    else if (a.beginDate == nil && a.endDate == nil){
        _ima1.hidden = YES;
        _lblDate.hidden = YES;
        _ima2.frame =CGRectMake(TMScreenW *20/320, TMScreenH *10/568 + CGRectGetMaxY(_lblTitle.frame), TMScreenW *10/320, TMScreenW *10/320);
        _headHeight = _headHeight + CGRectGetHeight(_lblTitle.frame);
    }
    

    if (a.introduction) {
//        
//        if (_ima1.hidden == YES) {
//            _headHeight = _headHeight - 20;
//            //重新布局下
//            _lblDesc.frame = CGRectMake(CGRectGetMaxX(_ima2.frame)+5, CGRectGetMinY(_ima2.frame), TMScreenW -70, descHeight);
//        }
        _btnShow.enabled = YES;
        _btnShow.hidden = NO;
    
        // @"活动介绍: %@"
        NSString *activityVC_viewTextContent_lblDesc2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblDesc2"];
        _lblDesc.text = [NSString stringWithFormat:activityVC_viewTextContent_lblDesc2,a.introduction];

//        CGSize size = CGSizeMake(_lblDesc.frame.size.width, TMScreenH *999/568);
//        CGSize labelSize = [_lblDesc.text sizeWithFont:_lblDesc.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        CGSize labelSize = [CommonUtils returnLabelSize:_lblDesc.text font:_lblDesc.font];
        
        
        //如果是小于等于5行的高度，则说明5行完全可以显示
        if(labelSize.height < TMScreenH *70/568){
            _btnShow.enabled = NO;
            _btnShow.hidden = YES;
            
            _lblDesc.frame = CGRectMake(CGRectGetMaxX(_ima2.frame)+ TMScreenW *5/320,CGRectGetMinY(_ima2.frame), labelSize.width, labelSize.height);
            _headHeight = _headHeight + labelSize.height + TMScreenH *20/568;
            //        重新计算高度
            _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _headHeight - CGRectGetMinY(_viewTextContent.frame));
            _tableHead.frame = CGRectMake(0, 0, TMScreenW, _headHeight);
        }
//        5行显示不下的时候
        else{
            _btnShow.hidden = NO;
            _btnShow.enabled = YES;
            _lblDesc.frame = CGRectMake(CGRectGetMaxX(_ima2.frame)+ TMScreenW *5/320,CGRectGetMinY(_ima2.frame), labelSize.width, descHeight);
            _headHeight = _headHeight + descHeight + TMScreenH *25/568;
            _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _headHeight - CGRectGetMinY(_viewTextContent.frame));
            _btnShow.frame = CGRectMake(0,CGRectGetMaxY(_viewTextContent.frame), _btnShow.frame.size.width, _btnShow.frame.size.height);
            _tableHead.frame = CGRectMake(0, 0, TMScreenW, _headHeight + CGRectGetHeight(_btnShow.frame));
        }
    }
//    如果没有活动内容的时候,隐藏活动图标,减少活动内容部分所占的位置
    else{
        
        _ima2.hidden = YES;
        _lblDesc.hidden = YES;
        _btnShow.enabled = NO;
        _btnShow.hidden = YES;
        _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _headHeight - CGRectGetMinY(_viewTextContent.frame));
        _headHeight = _headHeight + TMScreenH *10/568;
        _tableHead.frame = CGRectMake(0, 0, TMScreenW, _headHeight);
        
    }

    [_tableList setTableHeaderView:_tableHead];
    [_tableList reloadData];
}

//显示更多活动内容信息
- (void)showActivityDetail:(UIButton *)button {
    
    _headHeight = CGRectGetMinY(_viewTextContent.frame);
    _headHeight = _headHeight + CGRectGetMaxY(_lblDate.frame);
//    CGSize size = CGSizeMake(_lblDesc.frame.size.width, TMScreenH *999/568);
//    CGSize labelSize = [_lblDesc.text sizeWithFont:_lblDesc.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    CGSize labelSize = [CommonUtils returnLabelSize:_lblDesc.text font:_lblDesc.font];
    
    // @"收起详情"
    NSString *activityVC_viewTextContent_lblShow2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblShow2"];
    // @"展开详情"
    NSString *activityVC_viewTextContent_lblShow1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_viewTextContent_lblShow1"];
    if (_isShowed == NO) {
//        修改图片和按钮文字
        _imgShow.image = [UIImage imageNamed:@"newup"];
        _lblShow.text = activityVC_viewTextContent_lblShow2;
        _lblDesc.frame = CGRectMake(_lblDesc.frame.origin.x,CGRectGetMinY(_ima2.frame), labelSize.width, labelSize.height);
        _headHeight = _headHeight + labelSize.height + TMScreenH *20/568;
        
        if (_ima1.hidden == YES) {
            _headHeight = _headHeight - TMScreenH *20/568;
        }
        
//        重新计算高度
        _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _headHeight - CGRectGetMinY(_viewTextContent.frame) );
        _btnShow.frame = CGRectMake(0,CGRectGetMaxY(_viewTextContent.frame), _btnShow.frame.size.width, _btnShow.frame.size.height);
        _tableHead.frame = CGRectMake(0, 0, TMScreenW, _headHeight + CGRectGetHeight(_btnShow.frame));
        
        [self.tableList setTableHeaderView:_tableHead];
        
    }
//    
    else{
        //修改图片和按钮文字
        _imgShow.image = [UIImage imageNamed:@"newdown"];
        _lblShow.text = activityVC_viewTextContent_lblShow1;
        _lblDesc.frame = CGRectMake(_lblDesc.frame.origin.x,CGRectGetMinY(_ima2.frame), TMScreenW - TMScreenW *70/320, descHeight);

        _headHeight = _headHeight  + descHeight + TMScreenH *10/568;
        if (_ima1.hidden == YES) {
            _headHeight = _headHeight - TMScreenH *20/568;
        }
        _viewTextContent.frame = CGRectMake(0, _viewTextContent.frame.origin.y, _viewTextContent.frame.size.width, _headHeight - CGRectGetMinY(_viewTextContent.frame) );
        _btnShow.frame = CGRectMake(0,CGRectGetMaxY(_viewTextContent.frame), _btnShow.frame.size.width, _btnShow.frame.size.height);
        _tableHead.frame = CGRectMake(0, 0, TMScreenW, _headHeight + CGRectGetHeight(_btnShow.frame));
        
        [self.tableList setTableHeaderView:_tableHead];
    }
    _isShowed = !_isShowed;
    [_tableList reloadData];
}


- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        pagination.count = 20;
        [appProducts removeAllObjects];
    }
    [activityService getActivityListWithId:_activityId pagination:pagination];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if ([url isEqual:api_activity_productlist]){
        ListResponse * respobj = (ListResponse *)response;
        
        if (respobj.paginated.more > 0){
            [self.tableList setHasLoadingMore:YES];
        } else {
            [self.tableList setHasLoadingMore:NO];
        }
        
        if (respobj.status.succeed == 1) {
            [appProducts addObjectsFromArray:respobj.data];
            if (appProducts.count == 0){
//                [CommonUtils displayNoResultView:self.view frame:self.tableList.frame];
                // @"没有结果"
                NSString *activityVC_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"activityVC_noResultView_desc"];
                [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:activityVC_noResultView_desc];
                
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
                
                self.tableList.hidden = YES;
            } else {
                [_tableList reloadData];
                [CommonUtils removeNoResultView:self.view];
                self.tableList.hidden = NO;
            }
        }
        self.tableList.pullTableIsRefreshing = NO;
        self.tableList.pullTableIsLoadingMore = NO;
    }
    else if ([url isEqualToString:api_activity_content]){
        
        Response * respobj = (Response *)response;
        if (respobj.status.succeed == 1) {
            appActivity = (AppActivity *)respobj.data;
            
            if ([appActivity.type isEqualToString:@"staticHtml"]) {
                self.tableList.hidden = YES;
                NSString *strurl = [[NSString alloc] initWithFormat:@"%@%@%ld%@", api_host, @"activity/activityhtml.jhtm?id=", appActivity.id, @"&os=IOS" ];
                self.startPage = strurl;
                NSURL *url = [[NSURL alloc] initWithString:strurl];
                self.webView.backgroundColor = groupTableViewBackgroundColorSelf;
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
            else{
                
#pragma mark - 数据出错处理，error 返回后台
                
                self.tableList.hidden = NO;
                //self.startPage = api_host;
                //必须加载一个页面，或者商品详情页的规格选择出问题
                NSString *strurl = [[NSString alloc] initWithFormat:@"%@%@", api_host, @"common/blank.jhtm"];
                self.startPage = strurl;
                NSURL *url = [[NSURL alloc] initWithString:strurl];
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self configActivityInfo:appActivity];
                [self.tableList setHasLoadingMore:YES];
                [self loadData:NO];
            }
        }
    }
}
//将日期格式2000-01-01 改为 2000.01.01
- (NSString *)changeDateForm:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}
//#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = appProducts.count / 2;
    if (appProducts.count % 2 == 1){
        count = count + 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TMScreenH *235/568;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (!cell)
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ActivityCell" owner:self options:nil] lastObject];
    NSInteger row = indexPath.row * 2;
    AppProduct * p = [appProducts objectAtIndex:row];
    [cell setItem:p row:row appProducts:appProducts];
    [cell.btnTouch1 addTarget:self action:@selector(clickProd:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTouch2 addTarget:self action:@selector(clickProd:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)clickProd:(UIButton *)button{
    ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    prodInfo.productId = button.tag;
    [self.navigationController pushViewController:prodInfo animated:YES];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    [self loadData:YES];
    self.tableList.pullLastRefreshDate = [NSDate date];
    
}
- (void) loadMoreDataToTable
{
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
