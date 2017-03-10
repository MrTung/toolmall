//
//  ProductCountDownView.h
//  eshop
//
//  Created by gs_sh on 17/2/22.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCountDownViewDelegate <NSObject>

- (void)senMessageActivityisEnd;

@end


@interface ProductCountDownView : UIView
//{
//    dispatch_source_t _timer;
//}
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, weak) id<ProductCountDownViewDelegate> delegate;
@property dispatch_source_t timer;

@end
