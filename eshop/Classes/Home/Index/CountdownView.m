//
//  CountdownView.m
//  CountdownTest
//
//  Created by xiangning on 16/9/20.
//  Copyright © 2016年 sh. All rights reserved.
//

#import "CountdownView.h"

@interface CountdownView ()
{
//    dispatch_source_t _timer;
}
@end

@implementation CountdownView

//- (void)getDateTimeWithCountdown:(NSTimeInterval)timeInterval {
//    
//    NSDate *startDate = [NSDate date];
//    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *endDate = [dateFormatter dateFromString:endTime];
//    
//    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
//    
//    NSLog(@"%f", timeInterval);
//    
//    if (_timer==nil) {
//        __block int timeout = timeInterval; 倒计时时间<单位/秒>
//        
//        if (timeout!=0) {
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); 每秒执行
//            dispatch_source_set_event_handler(_timer, ^{
//                if(timeout<=0){ 倒计时结束，关闭
//                    dispatch_source_cancel(_timer);
//                    _timer = nil;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                self.dayLabel.text = @"";
//                        self.hhLabel.text = @"00";
//                        self.mmLabel.text = @"00";
//                        self.ssLabel.text = @"00";
//                    });
//                }else{
//                    int days = (int)(timeout/(3600*24));
//                                        if (days==0) {
//                    //                        self.dayLabel.text = @"";
//                                        }
//                    int hours = (int)((timeout-days*24*3600)/3600);
//                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//                    int second = timeout-days*24*3600-hours*3600-minute*60;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                if (days==0) {
//                                                    self.dayLabel.text = @"0天";
//                                                }else{
//                                                    self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
//                                                }
//                        if (hours<10) {
//                            self.hhLabel.text = [NSString stringWithFormat:@"0%d",hours];
//                        }else{
//                            self.hhLabel.text = [NSString stringWithFormat:@"%d",hours];
//                        }
//                        if (minute<10) {
//                            self.mmLabel.text = [NSString stringWithFormat:@"0%d",minute];
//                        }else{
//                            self.mmLabel.text = [NSString stringWithFormat:@"%d",minute];
//                        }
//                        if (second<10) {
//                            self.ssLabel.text = [NSString stringWithFormat:@"0%d",second];
//                        }else{
//                            self.ssLabel.text = [NSString stringWithFormat:@"%d",second];
//                        }
//                        
//                    });
//                    timeout--;
//                }
//            });
//            dispatch_resume(_timer);
//        }
//    }
//    
//    
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
