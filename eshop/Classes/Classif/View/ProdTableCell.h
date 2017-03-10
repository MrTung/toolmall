//
//  ProdTableCell.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import <UIKit/UIKit.h>


@interface ProdTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet EGOImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *brand;
@property (strong, nonatomic) IBOutlet UILabel *sn;
@property (strong, nonatomic) IBOutlet UILabel *makerModel;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *delPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnAddCart;
@property (nonatomic) IBOutlet UIImageView *hotImage;
@property int productId;

@property (nonatomic) id<MsgHandler> msgHandler;

- (void) myinit;
@end
