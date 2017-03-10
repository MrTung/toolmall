//
//  ProductPreheatView.m
//  eshop
//
//  Created by gs_sh on 17/2/22.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "ProductPreheatView.h"

@interface ProductPreheatView ()

@property (nonatomic, retain) EGOImageView *bacImg;
@property (nonatomic, retain) UILabel *dateLabel;

@end

@implementation ProductPreheatView

@synthesize bacImg;
@synthesize dateLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    CGFloat margin = kWidth*5/320;
    bacImg = [[EGOImageView alloc] initWithFrame:self.frame];
    [self addSubview:bacImg];
    
    dateLabel = [[UILabel alloc] initWithFrame:(CGRectMake(margin, 0, self.frame.size.width - margin*2, self.frame.size.height))];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontWithSize:10.0];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:dateLabel];
    
    [self.bacImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(TMScreenH *0/568);
        make.left.equalTo(self).offset(TMScreenW *0/320);
        make.right.equalTo(self).offset(-TMScreenW *0/320);
        make.bottom.equalTo(self).offset(- TMScreenH *0/568);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(TMScreenH *0/568);
        make.left.equalTo(self).offset(TMScreenW *10/320);
        make.right.equalTo(self).offset(-TMScreenW *8/320);
        make.bottom.equalTo(self).offset(- TMScreenH *0/568);
    }];
    
}


- (void)setBeginTime:(NSString *)beginTime {
    
    //    NSString * timeStampString = @"1423189125874";
    NSTimeInterval _interval=[beginTime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"MM月dd日 HH:mm:ss"];
    NSString *dateTime = [objDateformat stringFromDate: date];
    
    bacImg.image = [UIImage imageNamed:@"activityBegin.png"];
    dateLabel.text = [NSString stringWithFormat:@"%@ 开始", dateTime];
//    [dateLabel sizeToFit];
//    [dateLabel adjustsFontSizeToFitWidth];
    [self activityBegin:beginTime];
}

- (void)activityBegin:(NSString *)beginTime {
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString * timeStampString = beginTime;
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
                    
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        NSLog(@"%d - %d - %d - %d", days, hours, minute, second);
                        if (days == 0 && hours == 0 && minute == 0 && second == 1) {
                            
                            [_delegate senMessageActivityisBegin];
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
