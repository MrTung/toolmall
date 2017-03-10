//
//  CartItemCell.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import <UIKit/UIKit.h>
#import "CartController.h"

@protocol CartItemCellDelegate <NSObject>
- (void) selectCartItem:(NSIndexPath *)indexPath quantity:(int)quantity selected:(Boolean)selected;
@end

@interface CartCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,weak) id<CartItemCellDelegate> cartDelegate;

@property (nonatomic, strong) UITapGestureRecognizer * tap;
@property (nonatomic) NSIndexPath* indexPath;

@property (nonatomic) IBOutlet UIButton *btnChk;
@property (nonatomic) IBOutlet EGOImageView *image;
@property (nonatomic) IBOutlet UILabel *prodname;
@property (weak, nonatomic) IBOutlet UILabel *lblProdSpecName;
@property (nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *prodSpec;
@property (nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIView *commonContent; //普通视图，商品简单信息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonContentTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonContentBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayout;



@property(nonatomic,assign) UIView * parentView;

- (void)initParentView:(UIView *)view;

- (void)myinit;

@property (nonatomic, retain) AppCartItem *cartItem;

@end
