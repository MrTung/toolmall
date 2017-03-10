//
//  CartItemHeader.m
//  toolmall
//
//  Created by mc on 15/10/27.
//
//

#import "CartItemHeader.h"

@implementation CartItemHeader
@synthesize merchantName;
@synthesize merchantChk;
@synthesize section;
@synthesize  bgView;


- (void)myinit{
    [merchantChk setImage:[UIImage imageNamed:@"newcheckfalse"] forState:UIControlStateNormal];
    [merchantChk setImage:[UIImage imageNamed:@"newchecktrue"] forState:UIControlStateSelected];
//    [CommonUtils setGaryBottomBorder:self.bgView];
}
-(IBAction)checkboxClick:(UIButton*)sender
{
    merchantChk.selected = !merchantChk.selected;
    [self.headDelegate selectMerchant:section selected:merchantChk.selected];
}
@end
