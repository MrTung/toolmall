//
//  OrderListCell.m
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import "OrderListCell.h"

@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation OrderListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 商品编号:
    NSString *orderListCell_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListCell_label1_title"];
    // 品牌:
    NSString *orderListCell_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListCell_label2_title"];
    // 制造商型号:
    NSString *orderListCell_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListCell_label3_title"];
    
    self.label1.text = orderListCell_label1_title;
    self.label2.text = orderListCell_label2_title;
    self.label3.text = orderListCell_label3_title;
}


@end
