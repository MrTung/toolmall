//
//  OrderHeadView.m
//  eshop
//
//  Created by mc on 16/8/25.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "OrderHeadView.h"

#import "UIFont+Fit.h"

@implementation OrderHeadView

- (instancetype)initWithFrame:(CGRect)frame Name:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        imgAddress = [[UIImageView alloc] init];
        imgAddress.frame = CGRectMake(10, (self.frame.size.height - TMScreenW *18/320)/2, TMScreenW *18/320, TMScreenW *18/320);
        imgAddress.image = [UIImage imageNamed:@"address.png"];
        [self addSubview:imgAddress];
        
        UIView *receiver = [[UIView alloc] init];
        receiver.frame = CGRectMake(CGRectGetMaxX(imgAddress.frame)+TMScreenW *8/320, TMScreenH *8/568, frame.size.width - TMScreenW *70/320, TMScreenH *20/568);
        
        lblName = [[UILabel alloc] init];
        lblName.frame = CGRectMake(0, 0, receiver.frame.size.width/2, receiver.frame.size.height);
        lblName.font = [UIFont systemFontWithSize:13];
        lblName.textColor = [UIColor blackColor];
        
        lblPhone = [[UILabel alloc] init];
        lblPhone.frame = CGRectMake(receiver.frame.size.width/2, 0, receiver.frame.size.width/2, receiver.frame.size.height);
        lblPhone.textAlignment = NSTextAlignmentRight;
        lblPhone.font = [UIFont systemFontWithSize:13];
        lblPhone.textColor = [UIColor blackColor];

        if (name && phone) {
//            lblName.text = [NSString stringWithFormat:orderHeadView_lblReceiver_title2,name,phone];
            lblName.text = name;
            lblPhone.text = phone;
        }
        
        if (self.name && self.phone) {
//            lblName.text = [NSString stringWithFormat:orderHeadView_lblReceiver_title2,self.name,self.phone];
            lblName.text = self.name;
            lblPhone.text = self.phone;
        }

        [receiver addSubview:lblPhone];
        [receiver addSubview:lblName];
        [self addSubview:receiver];
        
//        [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(receiver.mas_top).offset(TMScreenH *0/568);
//            make.left.equalTo(receiver.mas_left).offset(TMScreenW *0/320);
//            make.bottom.equalTo(receiver.mas_bottom).offset(- TMScreenH *0/568);
////            make.width.equalTo(receiver.mas_width).multipliedBy(1/2).offset(- TMScreenW *0/320);
//        }];
//        [lblPhone mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(receiver.mas_top).offset(TMScreenH *0/568);
//            make.right.equalTo(receiver.mas_right).offset(-TMScreenW *0/320);
//            make.bottom.equalTo(receiver.mas_bottom).offset(- TMScreenH *0/568);
////            make.width.equalTo(receiver.mas_width).multipliedBy(1/2).offset(- TMScreenW *0/320);
//        }];

        
        
        lblAddress = [[UILabel alloc] init];
        lblAddress.frame = CGRectMake(CGRectGetMaxX(imgAddress.frame)+ TMScreenW *8/320, CGRectGetMaxY(receiver.frame) + TMScreenH *0/568, frame.size.width - TMScreenW *65/320, TMScreenH *35/568);
//        lblAddress.lineBreakMode = NSLineBreakByCharWrapping;
        lblAddress.numberOfLines = 0;
        lblAddress.font = [UIFont systemFontWithSize:13];
//        lblAddress.adjustsFontSizeToFitWidth = YES;
        lblAddress.textColor = [UIColor blackColor];
//        address = @"这个世界真美好这个世界真美好这个世界真美好这个世界真美好这个世界真美好这个世界真美好这个世界真美好这个世界真美好"; //测试
        
        if (address) {
//            lblAddress.text = [NSString stringWithFormat:orderHeadView_lblAddress_title2,address];
            lblAddress.text = address;
        }
        
        if (self.address) {
//            lblAddress.text = [NSString stringWithFormat:orderHeadView_lblAddress_title2,self.address];
            lblAddress.text = self.address;
        }
        
        [self addSubview:lblAddress];
        
        //计算出自适应的高度
//        CGSize size = CGSizeMake(lblAddress.frame.size.width, 1000);
//        CGSize labelSize = [lblAddress.text sizeWithFont:lblAddress.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//        CGSize labelSize = [CommonUtils returnLabelSize:lblAddress.text font:lblAddress.font];
        CGFloat labelWidth = frame.size.width - TMScreenW *65/320;
//        CGSize labelSize = [CommonUtils returnLabelSize:lblAddress.text font:lblAddress.font labelWidth:labelWidth];

        lblAddress.frame = CGRectMake(CGRectGetMaxX(imgAddress.frame)+ TMScreenW *8/320, CGRectGetMaxY(receiver.frame) + TMScreenW *0/320, labelWidth, TMScreenH *35/568);
//        if (name == nil && phone == nil) {
//            
//            self.frame = CGRectMake(0, 0, frame.size.width, TMScreenH *60/568);
//        } else {
//            self.frame = CGRectMake(0, 0, frame.size.width, CGRectGetMaxY(lblAddress.frame )+ TMScreenH *10/568);
//        }
        
        self.frame = CGRectMake(0, 0, frame.size.width, TMScreenH *70/568);
        
        imgAddress.frame = CGRectMake(10, (self.frame.size.height - TMScreenW *18/320)/2, TMScreenW *18/320, TMScreenW *18/320);
        
        UIImageView * imgArrow = [[UIImageView alloc] init];
        imgArrow.frame = CGRectMake(self.frame.size.width - TMScreenW *10/320 -10, (self.frame.size.height - TMScreenH *15/568)/2, TMScreenW *10/320, TMScreenH *15/568);
        imgArrow.image = [UIImage imageNamed:@"gray_right_arrow.png"];
        [self addSubview:imgArrow];
        
        UIImageView * imgLine = [[UIImageView alloc] init];
        imgLine.frame = CGRectMake(0, self.frame.size.height - TMScreenH *2/568, frame.size.width, TMScreenH *2/568);
        imgLine.image = [UIImage imageNamed:@"addressLine.png"];
        [self addSubview:imgLine];
        
        if (name == nil && phone == nil) {
            
            [receiver removeFromSuperview];

            lblAddress.frame = CGRectMake(CGRectGetMaxX(imgAddress.frame)+ TMScreenW *8/320, (self.frame.size.height - TMScreenH *70/568)/2, frame.size.width - TMScreenW *65/320, TMScreenH *70/568);

//             @"请添加你的收货地址"
            NSString *orderHeadView_lblAddress_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderHeadView_lblAddress_title"];
            lblAddress.text = orderHeadView_lblAddress_title;
        }
    }
    return self;
}


@end
