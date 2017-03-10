//
//  PromotionListCell.m
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PromotionListCell.h"

@implementation PromotionListCell
@synthesize prmoDesc;
@synthesize image;
- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLayuot];
    }
    return self;
}
//初始化控件
-(void)initLayuot{
    image = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_image.png"]];
    image.frame = CGRectMake(8, 8, self.frame.size.width, 40);
    [self addSubview:image];
    prmoDesc = [[UILabel alloc] initWithFrame:CGRectMake(8, 108, 250, 40)];
    //[prmoDesc setBackgroundColor:[UIColor redColor]];
    [self addSubview:prmoDesc];
}
- (void)setImageUrl:(NSString*)url{
    image.frame =CGRectMake(8, 8, self.frame.size.width - 16, 90);
    image.imageURL = [NSURL URLWithString:url];
}
- (void)setBrief:(NSString*)brief{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.prmoDesc.text = [CommonUtils filterHtml:brief];
    self.prmoDesc.font = [UIFont systemFontOfSize:13];
    [self.prmoDesc setTextColor:[UIColor darkGrayColor]];
    //设置label的最大行数
    self.prmoDesc.numberOfLines = 0;
    CGSize size = CGSizeMake(self.frame.size.width - 16, 1000);
    CGSize labelSize = [self.prmoDesc.text sizeWithFont:self.prmoDesc.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.prmoDesc.frame = CGRectMake(self.prmoDesc.frame.origin.x, self.prmoDesc.frame.origin.y, labelSize.width, labelSize.height);
    
    //计算出自适应的高度
    frame.size.height = labelSize.height+120;
    
    self.frame = frame;
}
@end
