//
//  OrderListCell.h
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet EGOImageView* image;
@property (strong, nonatomic) IBOutlet UILabel *prodName;
@property (strong, nonatomic) IBOutlet UILabel *prodSn;
@property (strong, nonatomic) IBOutlet UILabel *prodBrand;
@property (strong, nonatomic) IBOutlet UILabel *prodMakerModel;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *quantity;

@end
