//
//  FootViewItem.m
//  eshop
//
//  Created by mc on 16/4/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "FootViewItem.h"

#import "UIFont+Fit.h"

@implementation FootViewItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize image = _image;
@synthesize title = _title;
@synthesize price = _price;

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title price:(NSNumber *)price{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _imageview  = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"index_defImage"]];
        _imageview.frame = CGRectMake(self.frame.size.width/5.0, self.frame.size.height/12.0, 3*self.frame.size.width/5.0, 3*self.frame.size.width/5.0);
        _imageview.imageURL = [URLUtils createURL:image];
        [self addSubview:_imageview];
        
        
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *10/320, CGRectGetMaxY(_imageview.frame)+TMScreenH *3/568, self.frame.size.width - TMScreenW *20/320, 3*self.frame.size.height/12.0)];
        _lblName.text = title;
        _lblName.textAlignment = NSTextAlignmentCenter;
        _lblName.textColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1];
        _lblName.numberOfLines = 2;
        _lblName.font = [UIFont systemFontWithSize:9];
        _lblName.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_lblName];
        
        _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-self.frame.size.height/12.0-(TMScreenH *5/568), self.frame.size.width, self.frame.size.height/12.0)];
        _lblPrice.text = [CommonUtils formatCurrency:price];
        _lblPrice.textAlignment = NSTextAlignmentCenter;
        _lblPrice.textColor = [UIColor colorWithRed:197/255.0 green:0 blue:22/255.0 alpha:1];
        _lblPrice.font = [UIFont systemFontWithSize:10];
        [self addSubview:_lblPrice];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 1, 0, 0.5, self.frame.size.height)];
        line.backgroundColor = groupTableViewBackgroundColorSelf;
        [self addSubview:line];
//
    }
    
    return self;
}



@end
