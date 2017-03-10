//
//  PBAlertController.m
//  UIAlertController
//
//  Created by mc on 16/5/9.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "PBAlertController.h"

/** 屏幕尺寸 */
#define kMainScreenBounds [UIScreen mainScreen].bounds

@interface PBAlertController ()

/** 蒙版 */
@property (nonatomic, strong) UIView *coverView;
/** 弹框 */
@property (nonatomic, strong) UIView *alertView;
/** 点击确定回调的block */
@property (nonatomic, copy) PBBlock block;

@end

@implementation PBAlertController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)alertViewControllerWithMessage:(NSString *)message andBlock:(PBBlock) block{
    
    self.block = block;
    //创建蒙版
    UIView * coverView = [[UIView alloc] initWithFrame:kMainScreenBounds];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.666;
    
    //创建提示框view
    UIView * alertView = [[UIView alloc] init];
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = self.alertBackgroundColor;
    //设置圆角半径
    alertView.layer.cornerRadius = 6.0;
    self.alertView = alertView;
    [self.view addSubview:alertView];
    alertView.center = coverView.center;
    alertView.bounds = CGRectMake(0, 0, kMainScreenBounds.size.width * 0.92, kMainScreenBounds.size.width * 0.75 * 1.5/ 3);
    
//    //创建操作提示 label
//    UILabel * label = [[UILabel alloc] init];
//    [alertView addSubview:label];
//    label.text = @"操作提示";
//    label.font = [UIFont systemFontOfSize:19];
//    label.textAlignment = NSTextAlignmentCenter;
//    CGFloat lblWidth = alertView.bounds.size.width;
    CGFloat lblHigth = 22;
//    label.frame = CGRectMake(0, 0, lblWidth, lblHigth);
//    
//    //创建中间灰色分割线
//    UIView * separateLine = [[UIView alloc] init];
//    separateLine.backgroundColor = [UIColor grayColor];
//    [alertView addSubview:separateLine];
//    separateLine.frame = CGRectMake(0, lblHigth + 1, alertView.bounds.size.width, 1);
    
    //创建message label
    UILabel * lblMessage = [[UILabel alloc] init];
//    lblMessage.textColor = self.messageColor;
    [alertView addSubview:lblMessage];
    
    // @"提交成功，10元优惠券已经给您，是否前往优惠券列表查看？"
    NSString *pbAlertController_lblMessage_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"pbAlertController_lblMessage_title"];
    // @"优惠券列表"
    NSString *pbAlertController_lblMessage_redRange = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"pbAlertController_lblMessage_redRange"];
    // @"去看看"
    NSString *pbAlertController_btnConfirm_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"pbAlertController_btnConfirm_title"];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:pbAlertController_lblMessage_title];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:pbAlertController_lblMessage_redRange].location, [[noteStr string] rangeOfString:pbAlertController_lblMessage_redRange].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    
//    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:@"同意"].location, [[noteStr string] rangeOfString:@"同意"].length);
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:redRangeTwo];
    
    [lblMessage setAttributedText:noteStr];
//    
//    lblMessage.text = message;
//    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 2; //最多显示两行Message
    CGFloat margin = 0;
    CGFloat msgX = margin + 20;
    CGFloat msgY = lblHigth + 3;
    CGFloat msgW = alertView.bounds.size.width - 2 * msgX;
    CGFloat msgH = 88;
    lblMessage.frame = CGRectMake(msgX, msgY, msgW, msgH);
    
    //创建确定 取消按钮
    CGFloat buttonWidth = (alertView.bounds.size.width - 4 * margin) * 0.5;
    CGFloat buttonHigth = 36;
    UIButton * btnCancel = [[UIButton alloc] init];
    [alertView addSubview:btnCancel];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:self.btnCancelBackgroundColor];
    btnCancel.frame = CGRectMake(alertView.bounds.size.width - margin - buttonWidth, alertView.bounds.size.height - margin - buttonHigth, buttonWidth, buttonHigth);
    btnCancel.tag = 0;
    [btnCancel addTarget:self action:@selector(didClickBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
 
    //确定按钮
    UIButton * btnConfirm = [[UIButton alloc] init];
    btnConfirm.tag = 1;
    [alertView addSubview:btnConfirm];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setTitle:pbAlertController_btnConfirm_title forState:UIControlStateNormal];
    [btnConfirm setBackgroundColor:self.btnConfirmBackgroundColor];
    btnConfirm.frame = CGRectMake(margin, alertView.bounds.size.height - margin - buttonHigth, buttonWidth, buttonHigth);

    [btnConfirm addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
}

/** 点击确定 or 取消触发事件 */
-(void)didClickBtnConfirm:(UIButton *)sender{
//    self.block();
    if (self.delegate) {
        [self.delegate clickBtnConfirm];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickBtnCancel:(UIButton *)sender{
    if (self.delegate) {
        [self.delegate clickBtnCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

static PBAlertController * instance = nil;
+(instancetype)shareAlertController{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PBAlertController alloc] init];
    });
    return instance;
}

-(UIColor *)alertBackgroundColor{
    
    if (_alertBackgroundColor == nil) {
        _alertBackgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _alertBackgroundColor;
}

/** 确定按钮背景色 */
-(UIColor *)btnConfirmBackgroundColor{
    
    if (_btnConfirmBackgroundColor == nil) {
        _btnConfirmBackgroundColor = [UIColor colorWithRed:200/255.0 green:0 blue:22/255.0 alpha:1];
    }
    return _btnConfirmBackgroundColor;
}

/** 取消按钮背景色 */
-(UIColor *)btnCancelBackgroundColor{
    
    if (_btnCancelBackgroundColor == nil) {
        _btnCancelBackgroundColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1];
    }
    return _btnCancelBackgroundColor;
}

/** message字体颜色 */
-(UIColor *)messageColor{
    
    if (_messageColor == nil) {
        _messageColor = [UIColor blackColor];
    }
    return _messageColor;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
