//
//  CancelOrder.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPopup.h"

@protocol CancelOrderDelegate <NSObject>

- (void) complete:(int)cancelReason;

@end

@interface CancelOrder : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *pickerData;
}
@property (nonatomic) IBOutlet UIPickerView *pickerView;
@property id<CancelOrderDelegate> cancelOrderDelegate;

@end
