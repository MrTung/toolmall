//
//  ItemCell.m
//  ActionSheetExtension
//
//  Created by yixiang on 15/7/6.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell()

@property (nonatomic , strong) UIImageView *rightView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic , strong) Item  *item;

@end

@implementation ItemCell

//在initWithStyle中，生成控件，将控件添加到self.contentView中
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _rightView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _lineView = [[UIView alloc]init];

        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_rightView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_lineView];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//在layoutSubviews中，设置控件的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(TMScreenW *15/320, (CGRectGetHeight(self.frame)-  TMScreenH *20/568)/2, TMScreenW *150/320,  TMScreenH *20/568);
    _rightView.frame = CGRectMake(TMScreenW *270/320, (CGRectGetHeight(self.frame)-  TMScreenH *20/568)/2,  TMScreenH *20/568,  TMScreenH *20/568);
    _lineView.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    _lineView.backgroundColor = groupTableViewBackgroundColorSelf;
//    _titleLabel.textColor = [UIColor blueColor];
}

//设置数据
-(void)setData:(Item *)item{
    
    _item = item;
    if (item.icon) {
        _rightView.image = [UIImage imageNamed:item.icon];
    }else{
        _rightView.image = [UIImage imageNamed:@"descriptionIcon.png"];
    }

    _titleLabel.text = item.title;
}

//设置点击事件
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = RGBCOLOR(12, 102, 188);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
