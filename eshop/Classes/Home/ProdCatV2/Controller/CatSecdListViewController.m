//
//  CatSecdListViewController.m
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CatSecdListViewController.h"

#import "CatDetailTableViewCell.h"

@interface CatSecdListViewController ()<TypeSeleteDelegete>

@end

@implementation CatSecdListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [super addNavBackButton];
    
    prodCatService = [[ProductCategoryService alloc] initWithDelegate:self parentView:self.view];
    [super addThreedotButton];
    
    [prodCatService getChildren:[NSString stringWithFormat:@"%d", self.prodCategoryId]];
}

-(void)initView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, TMScreenW, TMScreenH-64)) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableView.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.navigationItem.title = self.prodCategoryName;

}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqualToString: api_productcat_children]){
        ProductCategoryListResponse * respobj = (ProductCategoryListResponse *)response;
        if (respobj.data.count > 0){
            
            secdGradeLists = respobj.data;
        }
        [self.tableView reloadData];
    }
}
#pragma TableView的处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return secdGradeLists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatDetailTableViewCell"];

    if (!cell) {
        cell = [CatDetailTableViewCell createCellWithTableView:tableView];
    }
    [cell removeAllSubviews];
    
    cell.delegate = self;
    cell.owner = self;
    
    AppProductCategory *secondModel = [secdGradeLists objectAtIndex:indexPath.row];
    cell.model = secondModel;

    return cell;
}

- (void)btnindex:(NSInteger)tag row:(NSInteger)row {

    AppProductCategory *secondModel = [secdGradeLists objectAtIndex:row];
    
    AppProductCategory *thirdModel = [secondModel.children objectAtIndex:tag];
    
    ProdList * prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    prodList.productCategoryId = thirdModel.id;
    
    [self.navigationController pushViewController:prodList animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    AppProductCategory *secondModel = [secdGradeLists objectAtIndex:indexPath.row];
    if (secdGradeLists.count>0) {
        
        return [CatDetailTableViewCell initWithdatasource:secondModel];
    } else {
        return 0;
    }
}

@end
