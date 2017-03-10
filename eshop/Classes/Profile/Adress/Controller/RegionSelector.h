//
//  RegionSelector.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressService.h"
#import "RegionResponse.h"
#import "Region.h"
#import "STPopup.h"

@protocol RegionSelectorDelegate <NSObject>

- (void)regionSelected:(int)regionId areaName:(NSString*)regionName;

@end

@interface RegionSelector : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate>{
    NSMutableArray * regionList;
    AddressService * addressService;
    int areaId;
    NSString *areaFullName;
}

@property (strong, nonatomic) IBOutlet UITableView *tableRegionList;
@property id<RegionSelectorDelegate> regionDelegate;

@end
