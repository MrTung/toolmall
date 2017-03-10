//
//  RecommendDetailView.h
//  eshop
//
//  Created by sh on 16/10/31.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendDetailView : UIView

@property (weak, nonatomic) IBOutlet EGOImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;

@end
