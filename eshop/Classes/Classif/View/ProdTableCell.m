//
//  ProdTableCell.m
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "ProdTableCell.h"

@implementation ProdTableCell
@synthesize image;
@synthesize name;
@synthesize brand;
@synthesize sn;
@synthesize makerModel;
@synthesize price;
@synthesize btnAddCart;
@synthesize productId;
@synthesize msgHandler;
- (void)awakeFromNib {
}

- (void) myinit{
    //[CommonUtils decrateGaryButton:self.btnAddCart];
    [CommonUtils decrateImageGaryBorder:self.image];
    self.name.baselineAdjustment = 0;
    self.image.placeholderImage = [UIImage imageNamed:@"index_defImage"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAddCart:(id)sender{
    Message * msg = [[Message alloc] init];
    msg.what = 1;
    msg.int1 = productId;
    [msgHandler sendMessage:msg];
}
@end
