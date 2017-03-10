//
//  RecommendView.h
//  eshop
//
//  Created by xiangning on 16/9/19.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendView : UIView

@property (weak, nonatomic) IBOutlet EGOImageView*imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;

@end
