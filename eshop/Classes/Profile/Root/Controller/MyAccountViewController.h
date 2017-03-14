//
//  MyAccountViewController.h
//  toolmall
//
//  Created by mc on 15/10/12.
//
//

#import <UIKit/UIKit.h>
#import "OrderList.h"
#import "ShopLoginViewController.h"
#import "UserInfoResponse.h"
#import "UserInfoService.h"
#import "AddressList.h"
#import "OrderNum.h"
//#import "SettingController.h"
#import "CouponCodeList.h"
#import "FavoriteListController.h"
#import "MyInfoViewController.h"
#import "ProductService.h"
#import "ImproveInfoViewController.h"
#import "FootPrintViewController.h"

@interface MyAccountViewController : UIBaseController<ServiceResponselDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
    BOOL reloading;
    
    UserInfoService *userInfoService;
    ProductService *productService;
}

- (void)reloadTableViewDataSource;

- (void)doneLoadingTableViewData;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIButton *btn_mobileno; // 手机显示
@property (strong, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UIImageView *img_profile;
@property (strong, nonatomic) IBOutlet UIButton *btn_profile; // 头像

@property (nonatomic) IBOutlet UIButton *btn_await_pay; // 待付款
@property (weak, nonatomic) IBOutlet UILabel *lab_await_pay_num;
@property (nonatomic) IBOutlet UIButton *btn_await_ship; // 待发货
@property (weak, nonatomic) IBOutlet UILabel *lab_await_ship_num;
@property (nonatomic) IBOutlet UIButton *btn_shipped; // 待收货
@property (weak, nonatomic) IBOutlet UILabel *lab_await_shiped_num;
@property (nonatomic) IBOutlet UIButton *btn_await_review; // 待评价
@property (weak, nonatomic) IBOutlet UILabel *lab_await_review_num;

@property (weak, nonatomic) IBOutlet UIImageView *imgPoint_YH;

@property (nonatomic) IBOutlet UIScrollView *footView; // 足迹

@property (nonatomic, strong) USER * user;

@property NSMutableArray * arrayFootprint; //用来存储足迹中的item;

@property (nonatomic, copy) NSString *type;

@end
