//
//  AddressListCell.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@protocol AddressListCellDelegate <NSObject>

- (void) sendMessage:(NSIndexPath*)indexPath tag:(NSInteger)tag;

@end
@interface AddressListCell : UITableViewCell
{
    UILabel *lbNameAndTel;
    UILabel *lbAddress;
//    UILabel *lbDefault;
    UIView *viewZone;
    UIButton *btnSetDefault;
    UIButton *btnEdit;
    UIButton *btnDelete;
    UIButton *btnSelect;
    
    UIImageView * ima1;
    UIImageView * ima2;
    UIImageView * ima3;
    UIImageView * imgLine;
    UIImageView *defaultImg;
    
    UIView * line;
    UILabel * label;
    UILabel * label2;
    UILabel * label3;
}



@property NSIndexPath *indexPath;
@property id<AddressListCellDelegate> msgDelegate;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//-(void)setAddress:(Address*)address isSelectAddress:(Boolean)isSelectAddress;
-(void)setAddress:(Address*)address isSelectAddress:(Boolean)isSelectAddress selectAddressId:(int)selectAddressId;

//- (CGFloat)returnCellHeight:(Address *)address;
- (CGFloat)returnCellHeight:(Address *)address isSelectAddress:(Boolean)isSelectAddress selectAddressId:(int)selectAddressId;

@end
