//
//  ProductCountDownView.m
//  eshop
//
//  Created by gs_sh on 17/2/22.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "ProductCountDownView.h"

@interface ProductCountDownView ()

@property (weak, nonatomic) IBOutlet UIView *bacView;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *dLab;
@property (weak, nonatomic) IBOutlet UILabel *hLab;
@property (weak, nonatomic) IBOutlet UILabel *mLab;
@property (weak, nonatomic) IBOutlet UILabel *sLab;

@property (weak, nonatomic) IBOutlet UILabel *labD;
@property (weak, nonatomic) IBOutlet UILabel *labH;
@property (weak, nonatomic) IBOutlet UILabel *labM;
@property (weak, nonatomic) IBOutlet UILabel *labS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bacViewHeightLayout;

@end

@implementation ProductCountDownView

- (void)refreshUI {

    self.bacViewHeightLayout.constant = kHeight*25/568;
    
    [self setNeedsUpdateConstraints];
}

- (void)setEndTime:(NSString *)endTime {
    
    [self refreshUI];
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString * timeStampString = endTime;
    NSTimeInterval _interval2=[timeStampString doubleValue] / 1000.0;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:_interval2];
//    NSLog(@"秒杀结束: %@", [objDateformat stringFromDate: endDate]);
    
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:nowDate];
    
//    NSLog(@"%f", timeInterval);
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间<单位/秒>
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ // 倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dLab.text = @"00";
                        self.hLab.text = @"00";
                        self.mLab.text = @"00";
                        self.sLab.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dLab.text = @"00";
                        }else{
                            self.dLab.text = [NSString stringWithFormat:@"%d",days];
                        }
                        if (hours<10) {
                            self.hLab.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hLab.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.mLab.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.mLab.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.sLab.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.sLab.text = [NSString stringWithFormat:@"%d",second];
                        }
//                        NSLog(@"%d - %d - %d - %d", days, hours, minute, second);
                        if (days == 0 && hours == 0 && minute == 0 && second == 1) {
                            
                            [_delegate senMessageActivityisEnd];
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
