//
//  RegionSelector.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "RegionSelector.h"

@interface RegionSelector ()

@end

@implementation RegionSelector
@synthesize tableRegionList;
@synthesize regionDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    areaFullName = @"";
    addressService = [[AddressService alloc] initWithDelegate:self parentView:self.view];
    [self loadData];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *regionSelector_nibName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"regionSelector_nibName_title"];
        self.title = regionSelector_nibName_title;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 300);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)loadData
{
    [addressService region:areaId];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_region]){
        RegionResponse * respobj = (RegionResponse *)response;
        regionList = respobj.data;
        if (regionList.count == 0){
            [self.regionDelegate regionSelected:areaId areaName:areaFullName];
        }
        [self.tableRegionList reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return regionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegionListCell"];
    if (!cell) {
        Region *region = [regionList objectAtIndex:indexPath.row];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font = [UIFont systemFontOfSize:17];
        label.text = region.name;
        [cell addSubview:label];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *region = [regionList objectAtIndex:indexPath.row];
    areaId = region.id;
    areaFullName = [areaFullName stringByAppendingString:region.name];
    [self loadData];
}

@end
