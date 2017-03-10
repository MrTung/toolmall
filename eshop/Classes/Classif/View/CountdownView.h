//
//  CountdownView.h
//  CountdownTest
//
//  Created by xiangning on 16/9/20.
//  Copyright © 2016年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *hhLabel;
@property (weak, nonatomic) IBOutlet UILabel *mmLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssLabel;

//- (void)getDateTimeWithCountdown:(NSTimeInterval)timeInterval;

@end
