//
//  ProductPreheatView.h
//  eshop
//
//  Created by gs_sh on 17/2/22.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductPreheatViewDelegate <NSObject>

- (void)senMessageActivityisBegin;

@end

@interface ProductPreheatView : UIView
//{
//    dispatch_source_t _timer;
//}
@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, weak) id<ProductPreheatViewDelegate> delegate;
@property  dispatch_source_t timer;

@end
