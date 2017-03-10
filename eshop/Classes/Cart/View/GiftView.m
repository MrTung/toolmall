//
//  GiftView.m
//  eshop
//
//  Created by mc on 16/7/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "GiftView.h"
static int giftImageH=60;
@implementation GiftView

- (instancetype)initWithFrame:(CGRect)frame giftImage:(NSString *)giftImage giftName:(NSString *)giftName giftSpec:(NSString *)giftSpec giftPrice:(NSNumber *)giftPrice giftAmount:(int)giftAmount meetDemands:(NSString *)meetDemands{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
//        
        _giftImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"index_defImage"]];
        _giftImage.imageURL = [URLUtils createURL:giftImage];
        
//        _giftImage = [[UIImageView alloc] init];
//        NSLog(@"customView------%@",[NSThread currentThread]);
        
        
//        [_giftImage performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:giftImage] waitUntilDone:NO];
        _giftImage.frame = CGRectMake(40, 20, giftImageH, giftImageH);
        [CommonUtils decrateImageGaryBorder:_giftImage];
        [self addSubview:_giftImage];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 1, 20)];
//        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        UILabel * lbMeetDemands = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImage.frame)+5, 0, 140, 20)];
        if(meetDemands){
            lbMeetDemands.text = meetDemands;
        }
        lbMeetDemands.textColor = [UIColor blackColor];
        lbMeetDemands.font = [UIFont systemFontOfSize:11];
        [self addSubview:lbMeetDemands];
        
        UILabel * lbGiftName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImage.frame)+5, CGRectGetMinY(_giftImage.frame), 140, 30)];
        if (giftName) {
            lbGiftName.text = giftName;
        }
        lbGiftName.textColor = [UIColor blackColor];
        lbGiftName.font = [UIFont systemFontOfSize:11];
        lbGiftName.numberOfLines = 0;
        lbGiftName.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:lbGiftName];
        
        UILabel * lbGiftSpec = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImage.frame)+5, CGRectGetMaxY(_giftImage.frame)-30, 140, 20)];
        if (giftSpec) {
            lbGiftSpec.text = giftSpec;
        }
        lbGiftSpec.textColor = [UIColor blackColor];
        lbGiftSpec.font = [UIFont systemFontOfSize:11];
        [self addSubview:lbGiftSpec];
        
        UILabel * lbGiftPrice = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width -10 -80, 30, 80, 20)];
        lbGiftPrice.textAlignment = NSTextAlignmentRight;
        if (giftPrice) {
            NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[CommonUtils formatCurrency:giftPrice]]];
            [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
            lbGiftPrice.attributedText = att;
        }
        lbGiftPrice.textColor = TMRedColor;
        lbGiftPrice.font = [UIFont systemFontOfSize:11];
        [self addSubview:lbGiftPrice];
        
        UILabel * lbGiftAmount = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width -10-80, CGRectGetMinY(lbGiftSpec.frame), 80, 20)];
        lbGiftAmount.textAlignment = NSTextAlignmentRight;
        if (giftAmount) {
            lbGiftAmount.text = [@"X " stringByAppendingString:[NSString stringWithFormat:@"%d",giftAmount]];
        }
        lbGiftAmount.textColor = [UIColor darkGrayColor];
        lbGiftAmount.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbGiftAmount];
        
    }
    return self;
}

@end
