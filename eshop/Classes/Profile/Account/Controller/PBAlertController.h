//
//  PBAlertController.h
//  UIAlertController
//
//  Created by mc on 16/5/9.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <UIKit/UIKit.h>

//制定一个协议
@protocol PBAlertControllerDelegate <NSObject>

//回传数据的协议方法
- (void)clickBtnConfirm;
- (void)clickBtnCancel;

@end

typedef void(^PBBlock)();

@interface PBAlertController : UIViewController

@property (nonatomic, strong) id <PBAlertControllerDelegate> delegate;
/** 设置alertView背景色 */
@property (nonatomic, copy) UIColor *alertBackgroundColor;
/** 设置确定按钮背景色 */
@property (nonatomic, copy) UIColor *btnConfirmBackgroundColor;
/** 设置取消按钮背景色 */
@property (nonatomic, copy) UIColor *btnCancelBackgroundColor;
/** 设置message字体颜色 */
@property (nonatomic, copy) UIColor *messageColor;

/** 创建单例 */
+(instancetype)shareAlertController;
/** 弹出alertView以及点击确定回调的block */
-(void)alertViewControllerWithMessage:(NSString *)message andBlock:(PBBlock)block;


@end
