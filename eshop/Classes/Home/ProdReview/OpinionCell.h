//
//  OpinionCell.h
//  eshop
//
//  Created by mc on 16/4/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"
@interface OpinionCell : UITableViewCell

@property (nonatomic) IBOutlet EGOImageView *image;
@property (strong, nonatomic) IBOutlet LPlaceholderTextView *content;


@end
