//
//  AddressListCell.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AddressListCell.h"

#import "UIFont+Fit.h"
@implementation AddressListCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLayuot];
    }
    return self;
}

- (void)initLayuot{
    
    CGFloat kb = TMScreenW *15/320;
    
//    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TMScreenW *320/320, TMScreenH *10/568)];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:whiteView];
//    lbNameAndTel = [[UILabel alloc] initWithFrame:CGRectMake(kb, CGRectGetMaxY(whiteView.frame), TMScreenW - 2*kb, TMScreenH *30/568)];
    
    lbNameAndTel = [[UILabel alloc] initWithFrame:CGRectMake(kb, TMScreenH *10/568, TMScreenW - 2*kb, TMScreenH *30/568)];
    
//    lbNameAndTel.textColor = [UIColor colorWithRed:19/255.0 green:10/255.0 blue:57/255.0 alpha:1];
    lbNameAndTel.textColor = [UIColor blackColor];
    lbNameAndTel.numberOfLines = 1;
    [lbNameAndTel setFont:[UIFont systemFontWithSize:14]];

    [self addSubview:lbNameAndTel];
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(kb, CGRectGetMaxY(lbNameAndTel.frame), TMScreenW - 2*kb, TMScreenH *40/568)];
    lbAddress.numberOfLines = 0;
//    lbAddress.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
    lbAddress.textColor = [UIColor darkGrayColor];
//    lbAddress.lineBreakMode = NSLineBreakByCharWrapping;
    [lbAddress setFont:[UIFont systemFontWithSize:13]];
    [self addSubview:lbAddress];
    
//    line = [[UIView alloc]initWithFrame:CGRectMake(kb, CGRectGetMaxY(lbAddress.frame), TMScreenW - 2*kb, 0.5)];
    line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbAddress.frame), TMScreenW, 0.5)];
    line.backgroundColor = groupTableViewBackgroundColorSelf;
    [self addSubview:line];
    
    // @"默认地址"
    NSString *addressListCell_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressListCell_label_title"];
    // @"编辑"
    NSString *addressListCell_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressListCell_label2_title"];
    // @"删除"
    NSString *addressListCell_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressListCell_label3_title"];
    // @"选择"
    NSString *addressListCell_btnSelect_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressListCell_btnSelect_title"];

    
    btnSetDefault = [[UIButton alloc] initWithFrame:CGRectMake(kb, CGRectGetMaxY(line.frame), TMScreenW *80/320, TMScreenW *30/320)];
    btnSetDefault.tag = 1;
    [self addSubview:btnSetDefault];
    ima1 = [[UIImageView alloc] initWithFrame:(CGRectMake(0, TMScreenW *7/320, TMScreenW *15/320, TMScreenW *15/320))];
    [btnSetDefault addSubview:ima1];
    label = [[UILabel alloc]initWithFrame:CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *60/320, TMScreenW *20/320)];
    label.text = addressListCell_label_title;
    label.font = [UIFont systemFontWithSize:12];
    label.textColor = [UIColor darkGrayColor];
    [btnSetDefault addSubview:label];
    

    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(TMScreenW - TMScreenW *120/320, CGRectGetMaxY(line.frame), TMScreenW *50/320, TMScreenW *30/320)];
    btnEdit.tag = 2;
    [self addSubview:btnEdit];
    ima2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, TMScreenW *7/320, TMScreenW *15/320, TMScreenW *15/320)];
    ima2.image = [UIImage imageNamed:@"addressEdit.png"];
    [btnEdit addSubview:ima2];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *30/320, TMScreenW *20/320)];
    label2.text = addressListCell_label2_title;
    label2.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
//    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont systemFontWithSize:12];
    [btnEdit addSubview:label2];
    
    
    btnDelete = [ [UIButton alloc] initWithFrame:CGRectMake(TMScreenW - TMScreenW *55/320, CGRectGetMaxY(line.frame),  TMScreenW *50/320, TMScreenW *30/320)];
    btnDelete.tag = 3;
    [self addSubview:btnDelete];
    
    ima3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, TMScreenW *7/320, TMScreenW *15/320, TMScreenW *15/320)];
    ima3.image = [UIImage imageNamed:@"addressDelete.png"];
    [btnDelete addSubview:ima3];
    
    label3 = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *30/320, TMScreenW *20/320)];
    label3.text = addressListCell_label3_title;
    label3.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
    label3.font = [UIFont systemFontWithSize:12];
    [btnDelete addSubview:label3];
    
    btnSelect = [ [UIButton alloc] initWithFrame:CGRectMake(TMScreenW - TMScreenW *55/320, CGRectGetMaxY(line.frame),  TMScreenW *50/320, TMScreenW *30/320)];
    [btnSelect setTitle:addressListCell_btnSelect_title forState:UIControlStateNormal];
    btnSelect.titleLabel.font = [UIFont systemFontWithSize:14];
    [btnSelect setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];

    btnSelect.tag = 4;
    [self addSubview:btnSelect];
    
    imgLine = [[UIImageView alloc] init];
    imgLine.frame = CGRectMake(0, CGRectGetMaxY(btnDelete.frame), kWidth, kHeight *2/568);
    imgLine.image = [UIImage imageNamed:@"addressLine.png"];
    [self addSubview:imgLine];
    
    [btnDelete addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    [btnSetDefault addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    
    defaultImg = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, TMScreenW *30/320, TMScreenW *30/320))];
    defaultImg.image = [UIImage imageNamed:@"addressDefault.png"];
}


-(void)setAddress:(Address*)address isSelectAddress:(Boolean)isSelectAddress selectAddressId:(int)selectAddressId {
    
    NSString *addressTxt = [[[NSString alloc] initWithString:address.areaName]  stringByAppendingString:address.address];
    lbAddress.text = addressTxt;
    
    NSString *nameandtel = [[[[NSString alloc] initWithString:address.consignee] stringByAppendingString:@"    "] stringByAppendingString:address.tel];
    lbNameAndTel.text = nameandtel;
    
    if (address.isDefault){
        ima1.image = [UIImage imageNamed:@"click2.png"];
//        [btnSetDefault setImage:[UIImage imageNamed:@"click2.png"] forState:UIControlStateNormal];
        //        lbDefault.hidden = NO;
    } else {
        
        ima1.image = [UIImage imageNamed:@"unclick2.png"];
//        [btnSetDefault setImage:[UIImage imageNamed:@"unclick2.png"] forState:UIControlStateNormal];
        //        lbDefault.hidden = YES;
    }
    
    if (isSelectAddress){
        [btnSetDefault removeFromSuperview];
        [btnDelete removeFromSuperview];
        [btnSelect removeFromSuperview];
        [line removeFromSuperview];
    } else {
        btnSelect.hidden = YES;
    }
    
    if (isSelectAddress && address.isDefault) {
        
        [self addSubview:defaultImg];
    } else {
        [defaultImg removeFromSuperview];
    }
    
    [self returnCellHeight:address isSelectAddress:isSelectAddress selectAddressId:selectAddressId];
}

- (CGFloat)returnCellHeight:(Address *)address isSelectAddress:(Boolean)isSelectAddress selectAddressId:(int)selectAddressId {
    
    CGFloat kb = TMScreenW *15/320;
    CGFloat totHeight = 0;
    
    lbNameAndTel.frame = CGRectMake(kb, TMScreenH *10/568, TMScreenW - 3*kb, TMScreenH *25/568);
    
    NSString *addressTxt = [[[NSString alloc] initWithString:address.areaName]  stringByAppendingString:address.address];
    lbAddress.text = addressTxt;
    
    //    CGSize labelSize = [CommonUtils returnLabelSize:lbAddress.text font:lbAddress.font];
    CGFloat labelWidth = kWidth-2*kb;
//    CGSize labelSize = [CommonUtils returnLabelSize:lbAddress.text font:lbAddress.font labelWidth:labelWidth];
    lbAddress.frame = CGRectMake(kb, CGRectGetMaxY(lbNameAndTel.frame) + TMScreenH *0/568, labelWidth, TMScreenH *40/568);
//    NSLog(@"\n labelSize: %@ \n lbAddress.frame: %@ \n", NSStringFromCGSize(labelSize), NSStringFromCGRect(lbAddress.frame));
    
    line.frame = CGRectMake(0, CGRectGetMaxY(lbAddress.frame)+TMScreenH *10/568, TMScreenW, 0.5);
    
    btnSetDefault.frame = CGRectMake(kb, CGRectGetMaxY(line.frame), TMScreenW *80/320, TMScreenW *30/320);
    ima1.frame = CGRectMake(0, TMScreenW *6/320, TMScreenW *18/320, TMScreenW *18/320);
    label.frame = CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *60/320, TMScreenW *20/320);
    
    btnEdit.frame = CGRectMake(TMScreenW - TMScreenW *120/320, CGRectGetMaxY(line.frame), TMScreenW *50/320, TMScreenW *30/320);
    ima2 .frame = CGRectMake(0, TMScreenW *7/320, TMScreenW *15/320, TMScreenW *15/320);
    label2.frame = CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *30/320, TMScreenW *20/320);
    
    btnDelete.frame = CGRectMake(TMScreenW - TMScreenW *55/320, CGRectGetMaxY(line.frame),  TMScreenW *50/320, TMScreenW *30/320);
    ima3.frame = CGRectMake(0, TMScreenW *7/320, TMScreenW *15/320, TMScreenW *15/320);
    label3.frame = CGRectMake(TMScreenW *20/320, TMScreenW *5/320, TMScreenW *30/320, TMScreenW *20/320);
    
    btnSelect.frame = CGRectMake(TMScreenW - TMScreenW *55/320, CGRectGetMaxY(line.frame),  TMScreenW *50/320, TMScreenW *30/320);
    
    imgLine.frame = CGRectMake(0, CGRectGetMaxY(btnDelete.frame), kWidth, kHeight*2/568);
    
    // 默认地址
    if (isSelectAddress) {
        
        imgLine.frame = CGRectMake(0, kHeight*83/568, kWidth, kHeight*2/568);
        CGFloat labelWidth = kWidth-3*kb;
//        CGSize labelSize = [CommonUtils returnLabelSize:lbAddress.text font:lbAddress.font labelWidth:labelWidth];
        
        lbNameAndTel.frame = CGRectMake(kb, TMScreenH *10/568, TMScreenW - 3*kb, TMScreenH *25/568);
        lbAddress.frame = CGRectMake(kb, CGRectGetMaxY(lbNameAndTel.frame) + TMScreenH *0/568, labelWidth, TMScreenH *40/568);
        
        btnEdit.frame = CGRectMake(kWidth - TMScreenW *30/320, TMScreenW *5/320, TMScreenW *30/320, TMScreenW *30/320);
        ima2.frame =CGRectMake(0, TMScreenW *5/320, TMScreenW *20/320, TMScreenW *20/320);
        [label2 removeFromSuperview];
//        imgLine.frame = CGRectMake(0, CGRectGetMaxY(lbAddress.frame)+TMScreenH *10/568, kWidth, kHeight*2/568);
    }
    // 当前选择地址
    if (selectAddressId == address.id) {
        
        imgLine.frame = CGRectMake(0, kHeight*83/568, kWidth, kHeight*2/568);
        CGFloat labelWidth = kWidth-5*kb;
//        CGSize labelSize = [CommonUtils returnLabelSize:lbAddress.text font:lbAddress.font labelWidth:labelWidth];
        
        lbNameAndTel.textColor = redColorSelf;
        lbNameAndTel.frame = CGRectMake(kb * 3, TMScreenH *10/568, labelWidth, TMScreenH *25/568);
        lbAddress.frame = CGRectMake(kb * 3, CGRectGetMaxY(lbNameAndTel.frame) + TMScreenH *0/568, labelWidth, TMScreenH *40/568);

//        imgLine.frame = CGRectMake(0, CGRectGetMaxY(lbAddress.frame)+TMScreenH *10/568, kWidth, kHeight*2/568);
        
        UIImageView *selectImg = [[UIImageView alloc] initWithFrame:(CGRectMake(kb/2, (CGRectGetMaxY(imgLine.frame) - TMScreenW *30/320)/2, TMScreenW *30/320, TMScreenW *30/320))];
        selectImg.image = [UIImage imageNamed:@"addressSelect.png"];
        [self addSubview:selectImg];
        //        self.backgroundColor = redColorSelf;
    }
//    lbAddress.adjustsFontSizeToFitWidth = YES;
    totHeight = CGRectGetMaxY(imgLine.frame);

    CGRect frame = [self frame];
    frame.size.height = totHeight;
    
    self.frame = frame;
    
    return totHeight;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)clickButtons:(UIButton*)sender{
    [self.msgDelegate sendMessage:self.indexPath tag:sender.tag];
}


@end
