//
//  CodeActionSheet.h
//  eshop
//
//  Created by mc on 16/4/18.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeActionSheet : UIView
{
    UIButton * cancelButton;
    UIView * coverView;
    UIImageView * imageview;
}
@property(nonatomic,strong)UIImageView * backgroundImageView;
-(id)initWithImageCode:(UIImage *)image;
-(void)showInView:(UIView *)view;
-(void)dissmiss;

@end
