//
//  Cart.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import <UIKit/UIKit.h>
#import "CartService.h"
#import "AppCart.h"
#import "CartItemHeader.h"
#import "OrderController.h"
#import "PullTableView.h"

#import "CartCell.h"
//#import "CartGiftView.h"
//#import "CartProHeader.h"
//#import "CartDiscountView.h"

#import "GiftView.h"
#import "CartPromotionDiscountView.h"
#import "CartPromotionTitleView.h"
#import "CartHeadView1.h"
@interface CartController : UIBaseController

@property (nonatomic) IBOutlet PullTableView *cartTable;
@property (nonatomic) IBOutlet UIButton *btnSelAll;
@property (nonatomic) IBOutlet UILabel *lbTotalAmount;
@property (nonatomic) IBOutlet UIView *cartFooter;
@property (nonatomic) IBOutlet UIView *btmView;
@property (nonatomic) IBOutlet UIView *noResultView;
@property Boolean hasBottomBar;

@property (nonatomic, strong) CartHeadView1 * firstOrderFreeHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

//@property (nonatomic, copy) NSString *type;

@property (nonatomic, retain) UIView *keyView;

@end
