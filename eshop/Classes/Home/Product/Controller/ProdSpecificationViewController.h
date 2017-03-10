//
//  ProdSpecificationViewController.h
//  eshop
//
//  Created by mc on 16/3/9.
//  Copyright © 2016年 hzlg. All rights reserved.
//


#import "CDVViewController.h"
#import "STPopup.h"
#import "SelProdSpecPlugin.h"
#import "AppGoods.h"

@interface ProdSpecificationViewController : CDVViewController <MsgHandler>{
    AppProduct *myproduct;
}

@property(nonatomic) IBOutlet EGOImageView* prodImage;
@property(nonatomic) IBOutlet UILabel* lbPrice;
@property(nonatomic) IBOutlet UILabel* lbSpecs;
@property id<MsgHandler> msgHandler;

- (void)setProduct:(AppProduct*)product;

- (instancetype)myInitWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil product:(AppProduct *)product;

@end
