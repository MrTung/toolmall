//
//  CartItemHeader.h
//  toolmall
//
//  Created by mc on 15/10/27.
//
//

#import <UIKit/UIKit.h>
@protocol CartItemHeadDelegate <NSObject>
- (void) selectMerchant:(NSInteger)section selected:(Boolean)selected;
@end

@interface CartItemHeader : UITableViewHeaderFooterView

@property (nonatomic) IBOutlet UIButton *merchantName;
@property (nonatomic) IBOutlet UIButton *merchantChk;
@property (nonatomic,weak) id<CartItemHeadDelegate> headDelegate;
@property (nonatomic) NSInteger section;
@property (nonatomic) IBOutlet UIView *bgView;
- (void)myinit;
@end
