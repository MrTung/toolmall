//
//  CodeActionSheet.m
//  eshop
//
//  Created by mc on 16/4/18.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CodeActionSheet.h"

@implementation CodeActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(id)initWithImageCode:(UIImage *)image{
    
    if (self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.6f];
        [coverView addGestureRecognizer:tap];
        //        coverView.backgroundColor = [UIColor cyanColor];
        coverView.hidden = YES;
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"sharebg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:110]];
        self.backgroundImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundImageView];

        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(self.frame.size.width-20-10,
                                        0,20, 20);
        [cancelButton setImage:[UIImage imageNamed:@"share_close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        imageview = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageview];
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width,200);
    self.backgroundImageView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    cancelButton.frame = CGRectMake(self.frame.size.width-26-10,
                                    10,26, 26);
    imageview.frame = CGRectMake(self.frame.size.width/2.0 - 60, self.frame.size.height/2.0 -60, 120, 120);
    [view addSubview:coverView];
    [view addSubview:self];
    [UIView beginAnimations:@"ShowCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    coverView.hidden = NO;
    [UIView commitAnimations];
}

-(void)dissmiss
{
    [UIView beginAnimations:@"DismissCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(sheetDidDismissed)];
    coverView.hidden = YES;
    [UIView commitAnimations];
}

-(void)sheetDidDismissed
{
    [coverView removeFromSuperview];
    [self removeFromSuperview];
}


@end
