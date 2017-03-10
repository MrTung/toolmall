//
//  ProdList.h
//  toolmall
//
//  Created by mc on 15/10/24.
//
//

#import <UIKit/UIKit.h>

#import "ProductService.h"
#import "AppProduct.h"
#import "ProdTableCell.h"
//#import "ProdInfo.h"
#import "ProductInfoViewController.h"
#import "PullTableView.h"
#import "ProdTableCellTable.h"
#import "SearchService.h"
//#import "CodeScan.h"
#import "ProdHotKeySearchViewController.h"
#import "UILabel+Vertical.h"
#import "UILine.h"
@interface ProdList : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate, UITabBarControllerDelegate,UIAlertViewDelegate, MsgHandler, PullTableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>{

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (strong, nonatomic) IBOutlet PullTableView *tableProducts;
@property (nonatomic,weak) IBOutlet UIButton *btnTopSort;
@property (nonatomic,weak) IBOutlet UIButton *btnSaleSort;
@property (nonatomic,weak) IBOutlet UIButton *btnPriceSort;
@property (nonatomic,weak) IBOutlet UIImageView *imgPriceDesc;
@property (nonatomic,weak) IBOutlet UIImageView *imgPriceAsc;
@property (nonatomic,weak) IBOutlet UIView *topView;
@property (nonatomic,weak) IBOutlet UILine *line2;

@property (nonatomic,weak) IBOutlet UIScrollView *attrFilterView;

//@property Boolean isKeyboardSearch;
@property(nonatomic,getter=isSearch) Boolean isSearch;
@property(nonatomic,copy) NSString * oldSearchKeyWord;
@property(nonatomic,copy) NSString * searchKeyWord;
@property(nonatomic,copy) NSString * orderType;
@property(nonatomic,assign) int productCategoryId; // 分类ID<二级分类页面>
@property(nonatomic,assign) int brandId; // 品牌商品列表<更多品牌>
@property(nonatomic) NSInteger promotionId; // 促销ID<购物车促销Bar>
@property(nonatomic,assign) int activityId;
@property(nonatomic,assign) int tagId; // 热卖推荐列表<我的收藏>
@property(nonatomic,assign) int couponId; // 优惠券适用商品ID<优惠券详情>

@property Boolean hasMoreData;

@end
