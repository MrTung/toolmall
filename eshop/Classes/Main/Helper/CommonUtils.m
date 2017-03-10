//
//  CommonUtils.m
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "CommonUtils.h"

#import "UIFont+Fit.h"
#import "UILine.h"
#import <Foundation/Foundation.h>

@implementation CommonUtils

+ (Boolean)chkLogin:(UIViewController*)controller gotoLoginScreen:(Boolean)gotoLoginScreen{
    SESSION *session = [SESSION getSession];
    if (session.uid < 0){
        if (gotoLoginScreen){
            ShopLoginViewController *loginVC = [[ShopLoginViewController alloc] initWithNibName:@"ShopLoginViewController" bundle:nil];
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
            controller.navigationItem.backBarButtonItem = barButtonItem;
            [controller.navigationController pushViewController:loginVC animated:YES];
        }
        return false;
    }
    return true;
}

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.label.text = text;
//        hud.dimBackground = YES;
    
    // 是否强制设为正方形
    hud.square = NO;
    hud.margin = TMScreenW *15/320;
    [hud showAnimated:YES];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    //HUD.labelText = text;
    HUD.bezelView.color = [UIColor blackColor];
//    [HUD setColor:[UIColor blackColor]];
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:14];
    HUD.mode = MBProgressHUDModeText;
    HUD.margin = TMScreenW *10/320;
    
    // 搜索界面，提示框上移、
    // @"禁止搜索空字符串"
    NSString *prodHotKeySearchVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_toastNotification_msg1"];
    if ([text isEqualToString:prodHotKeySearchVC_toastNotification_msg1]) {
        HUD.offset = CGPointMake(0, - TMScreenH *50/568);
    }
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
//        HUD.yOffset = 100.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    //HUD.labelText = text;
    HUD.bezelView.color = [UIColor blackColor];
    //    [HUD setColor:[UIColor blackColor]];
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:14];
    HUD.mode = MBProgressHUDModeText;
    HUD.margin = TMScreenW *10/320;
//    HUD.opacity = 0.6;
    // 修改背景透明度
    HUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    HUD.offset = CGPointMake(0, - TMScreenH *110/568);
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    //        HUD.yOffset = 100.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


+ (NSString *)formatCurrency:(NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    NSString *string = [formatter stringFromNumber:number];
    if ([string containsString:@"US$"]) {
        string = [string stringByReplacingOccurrencesOfString:@"US$" withString:@"¥"];
    }
    if ([string containsString:@"$"]) {
        string = [string stringByReplacingOccurrencesOfString:@"$" withString:@"¥"];
    }
    
    return string;
}

/** Label 展示不同大小字体|是否添加横划线*/
+ (NSMutableAttributedString *)getFormatCurrencyAttributedStringFromString:(NSString *)string isDelegate:(BOOL)isDelagate {

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    // 添加横划线
    if (isDelagate) {
        
        [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attString.length)];
    }
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:8.0] range:NSMakeRange(0, 1)];
    
    return attString;
}


/** Label 展示不同大小字体 - 价格突出*/
+ (NSMutableAttributedString *)getProductPriceAttributedStringFromString:(NSString *)string {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSArray *httpArr = [string componentsSeparatedByString:@"."];
    
    NSString *priceStr = httpArr.firstObject;
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:16.0] range:NSMakeRange(1, priceStr.length)];
    
    return attString;
}

+ (NSString *) intToString:(int) intValue{
    if (intValue == nil || intValue == [NSNull null]){
        return [NSNull null];
    } else {
        return [NSString stringWithFormat:@"%d", intValue];
    }
}

+ (void) fillIntToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(int)value{
    if (value != nil && value != [NSNull null]){
        [dictionary setObject:[NSString stringWithFormat:@"%d", value] forKey:key];
    }
}

+ (void) fillBooleanToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(Boolean)value{
    if (value != nil && value != [NSNull null]){
        if (value){
            [dictionary setObject:@"1" forKey:key];
        } else {
            [dictionary setObject:@"0" forKey:key];
        }
    }
}

+ (void) fillStrToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(NSString *)value{
    if (value != nil && value != [NSNull null]){
        [dictionary setObject:value forKey:key];
    }
}

+ (void) fillDicToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(NSDictionary *)value {
    if (value != nil && value != [NSNull null]){
        [dictionary setObject:value forKey:key];
    }
}

+ (NSString*)ArrayToJson:(NSMutableArray *)obj
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"ArrayToJson:");
//    NSLog(@"%@", jsonString);
    return jsonString;
}

+ (NSString *)DictionaryToJsonString:(NSDictionary*)dic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)formatDate:(NSDate*)date{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat: @"yyyy-MM-dd"]; // 2009-02-01 19:50:41 PST
//    NSNumber *number = (NSNumber*)date;
//
//    NSString *dateString = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[number doubleValue] / 1000]];
//    return dateString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd"]; // 2009-02-01 19:50:41 PST
    NSNumber *number = (NSNumber*)date;
    
    NSString *dateString = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[number doubleValue] / 1000]];
    return dateString;
}

//yyyy-MM-dd  ->  yyyy.MM.dd
+ (NSString *)changeDateFormatLineWithDot:(NSDate *)date{
    NSString * string = [self formatDate:date];
    return [string stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

+ (NSString *)formatDateTime:(NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd hh:mm:ss"]; // 2009-02-01 19:50:41 PST
    NSNumber *number = (NSNumber*)date;
    
    NSString *dateString = [dateFormat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[number doubleValue] / 1000]];
    return dateString;
}

+ (void) decrateGaryButton:(UIButton*)button{
    // Initialization code
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:6];
    [button.layer setBorderWidth:0.5];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
     CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){192.0/255,192.0/255,192.0/255,1});
     
     [button.layer setBorderColor:color];
}

+ (void) decrateRedButton:(UIButton*)button{
    // Initialization code
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:3];
    [button.layer setBorderWidth:0.5];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
    
    [button.layer setBorderColor:color];
}

+ (void) decrateFullFillRedButton:(UIButton*)button title:(NSString*)title{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setFont:[UIFont systemFontWithSize:13]];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
}
/** 给图片加边界 */
+ (void) decrateImageGaryBorder:(UIImageView*)image{
    //[image.layer setMasksToBounds:YES];
    [image.layer setBorderWidth:0.5];//设置边界的宽度
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){240.0/255,240.0/255,240.0/255,1});
    [image.layer setBorderColor:color];
//    groupTableViewBackgroundColorSelf
}

+ (void) decrateViewGaryBorder:(UIView*)view{
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:0.5];//设置边界的宽度
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){240.0/255,240.0/255,240.0/255,1});
    [view.layer setBorderColor:color];
}
//加上删除线
+ (NSAttributedString *)addDeleteLineOnLabel:(NSString *)string{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:string];
    [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
    return att;
}
//给数字加上删除线
+ (NSAttributedString *)addDeleteLineOnNumber:(NSNumber *)number{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",number]];
    [att addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, att.length)];
    return att;
}


+ (void) addBorderOnButton:(UIButton *)button{
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
}
+ (void) addBorderOnUITextField:(UITextField *)textField{
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 3;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
}

//13166668888 -> 131****8888
+ (NSString *)changeMobileNumberFormatter:(NSString *)string{
    return [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

+ (void) setGaryBottomBorder:(UIView*)view{
    UILine *line=[[UILine alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    [view addSubview:line];
}

+ (void) addGaryLine:(UIView*)view frame:(CGRect)frame{
    UILine *line=[[UILine alloc] initWithFrame:frame];
    [view addSubview:line];
}

//屏蔽表格多余空行的分割线
+ (void) setExtraCellLineHidden:(UITableView*)table{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

+ (void) decrateViewCornerBorderAndShadow:(UIView*)view{
    view.layer.cornerRadius = 4;
    //view.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOffset = CGSizeMake(2,2);
    view.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    view.layer.shadowRadius = 4;//阴影半径，默认3
}


+ (NSString*)trim:(NSString*)value{
    // 去除空格
    NSString *str2 = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str2;
}
+ (void)displayNoResultView:(UIView*)view{
    [CommonUtils removeNoResultView:view];
    UIView *noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
    noResultView.tag = 999998;
    float imageX = view.frame.size.width / 2 - 40;
//    float imageY = view.frame.size.height / 2 - 30;
    float imageY = 40;
//    float wordY = imageY - 60;
    float wordY = imageY * 3;
    UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, view.frame.size.width, 30)];
    [word setTextColor:[UIColor blackColor]];
    [word setTextAlignment:NSTextAlignmentCenter];
    // @"没有结果"
    NSString *commonUtils_noResultView1_text = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_noResultView1_text"];
    [word setText:commonUtils_noResultView1_text];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, 120, 78)];
    image.image = [UIImage imageNamed:@"no_result.png"];
    [noResultView addSubview:word];
    [noResultView addSubview:image];
    [view addSubview:noResultView];
}

+ (void)removeNoResultView:(UIView*)view{
    [[view viewWithTag:999998] removeFromSuperview];
}

+ (void)displayNoResultView:(UIView*)view frame:(CGRect)frame{
    [CommonUtils removeNoResultView:view];
    UIView *noResultView = [[UIView alloc] initWithFrame:frame];
    noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
    noResultView.tag = 999998;
    float imageX = frame.size.width / 2 - TMScreenW *40/320;
    float imageY = frame.size.height / 2 - TMScreenH *150/568;
    float wordY = imageY + TMScreenH *100/568;
    UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, frame.size.width, TMScreenH *30/568)];
    [word setTextColor:[UIColor lightGrayColor]];
    [word setTextAlignment:NSTextAlignmentCenter];
    // @"没有结果"
    NSString *commonUtils_noResultView2_text = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_noResultView2_text"];
    [word setText:commonUtils_noResultView2_text];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, TMScreenW *80/320, TMScreenH *80/568)];
    image.image = [UIImage imageNamed:@"no_result.png"];
    [noResultView addSubview:word];
    [noResultView addSubview:image];
    [view addSubview:noResultView];
    
}

+ (void)displayNoResultView:(UIView*)view frame:(CGRect)frame title:(NSString *)title{
    [CommonUtils removeNoResultView:view];
    UIView *noResultView = [[UIView alloc] initWithFrame:frame];
    noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
    noResultView.tag = 999998;
    float imageX = frame.size.width / 2 - TMScreenW *40/320;
    float imageY = frame.size.height / 2 - TMScreenH *150/568;
    float wordY = imageY + TMScreenH *100/568;
    UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, frame.size.width, TMScreenH *30/568)];
    [word setTextColor:[UIColor lightGrayColor]];
    [word setTextAlignment:NSTextAlignmentCenter];
    [word setText:title];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, TMScreenW *80/320, TMScreenH *80/568)];
    image.image = [UIImage imageNamed:@"no_result.png"];
    [noResultView addSubview:word];
    [noResultView addSubview:image];
    [view addSubview:noResultView];
    
}


//订单页专用
+ (void)displayOrderNoResultView:(UIView*)view frame:(CGRect)frame{
    [CommonUtils removeNoResultView:view];
    UIView *noResultView = [[UIView alloc] initWithFrame:frame];
    noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
    noResultView.tag = 999998;
    float imageX = view.frame.size.width / 2 - TMScreenW *40/320;
    float imageY = TMScreenH *80/568;
    float wordY = imageY*2 + TMScreenH *25/568;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, TMScreenW *80/320, TMScreenW *80/320)];
    image.image = [UIImage imageNamed:@"无订单"];
    
    UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, frame.size.width, TMScreenH *30/568)];
    [word setTextAlignment:NSTextAlignmentCenter];
    // @"您还没有相关的订单"
    NSString *commonUtils_orderNoResultView_text = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_orderNoResultView_text"];
    word.text = commonUtils_orderNoResultView_text;
    word.font = [UIFont systemFontWithSize:15.0];
    word.textColor = [UIColor darkGrayColor];
    
    [noResultView addSubview:word];
    [noResultView addSubview:image];
    [view addSubview:noResultView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY + TMScreenH *40/568, frame.size.width, TMScreenH *25/568)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontWithSize:13.0];
    // @"您可以去 首页 逛逛..."
    NSString *commonUtils_orderNoResultView_linkString = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_orderNoResultView_linkString"];
    // @"首页"
    NSString *commonUtils_orderNoResultView_range = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_orderNoResultView_range"];
    NSMutableAttributedString * linkString = [[ NSMutableAttributedString alloc] initWithString:commonUtils_orderNoResultView_linkString];
    NSRange range = [[linkString string]rangeOfString:commonUtils_orderNoResultView_range];
    [linkString addAttribute:NSForegroundColorAttributeName value:redColorSelf range:range];
    [linkString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    label.attributedText = linkString;
    
    [noResultView addSubview:label];
    
    label.userInteractionEnabled = YES;
    //创建一个单击手势对象
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToIndexPage)];
    //设置点击次数
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    //单指单击
    [label addGestureRecognizer:tap1];
}


+ (void)displayCollectionNoResultView:(UIView*)view frame:(CGRect)frame desc:(NSString *)desc{
    [CommonUtils removeNoResultView:view];
    UIView *noResultView = [[UIView alloc] initWithFrame:frame];
    noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
    noResultView.tag = 999998;
    
    float imageX = view.frame.size.width / 2 - TMScreenW *40/320;
    float imageY = TMScreenH *80/568;
    float wordY = imageY*2 + TMScreenH *25/568;
 
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, TMScreenW *80/320, TMScreenW *80/320)];
    
    // @"您还没有收藏过商品"
    NSString *favoriteListController_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_noResultView_desc"];
    // @"消息功能正在紧急上线中"
    NSString *msgList_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"msgList_noResultView_desc"];
    if ([desc isEqualToString:favoriteListController_noResultView_desc]) {
        image.image = [UIImage imageNamed:@"收藏夹无"];
    }
    else if ([desc isEqualToString:msgList_noResultView_desc]) {
        image.image = [UIImage imageNamed:@"forget_psw_pic"];
        image.frame = CGRectMake(imageX-TMScreenW *5/320, imageY, TMScreenW *80/320, TMScreenW *80/320);
    }
    else {
        image.image = [UIImage imageNamed:@"no_result.png"];
    }
//    image.image = [UIImage imageNamed:@"forget_psw_pic"];
    [noResultView addSubview:image];
    [view addSubview:noResultView];
    
    UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, frame.size.width, TMScreenH *30/568)];
    word.text = desc;
    word.font = [UIFont systemFontWithSize:15.0];
    word.textColor = [UIColor darkGrayColor];
    word.textAlignment = NSTextAlignmentCenter;
    [noResultView addSubview:word];

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY + TMScreenH *40/568, frame.size.width, TMScreenH *25/568)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontWithSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    // @"您可以去 首页 逛逛..."
    NSString *commonUtils_collectionNoResultView_linkString = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_collectionNoResultView_linkString"];
    // @"首页"
    NSString *commonUtils_collectionNoResultView_range = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_collectionNoResultView_range"];
    NSMutableAttributedString * linkString = [[ NSMutableAttributedString alloc] initWithString:commonUtils_collectionNoResultView_linkString];
    NSRange range = [[linkString string]rangeOfString:commonUtils_collectionNoResultView_range];
    [linkString addAttribute:NSForegroundColorAttributeName value:redColorSelf range:range];
    [linkString addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:14] range:NSMakeRange(0, linkString.length)];
    [linkString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    label.attributedText = linkString;
    [noResultView addSubview:label];
    label.userInteractionEnabled = YES;
    //创建一个单击手势对象
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToIndexPage)];
    //设置点击次数
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    //将单击手势加载到label上
    [label addGestureRecognizer:tap];
}


+ (void)jumpToIndexPage{
    
    NSNotification * notice = [NSNotification notificationWithName:TMPop2IndexNotificationName object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];

}

+ (void) alertUnExpectedError:(NSError*)error view:(UIView*)view{
    
    #ifdef DEBUG
    // @"获取数据失败"
    NSString *commonUtils_alertUnExpectedError_debug = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_alertUnExpectedError_debug"];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:commonUtils_alertUnExpectedError_debug
                                                     message:[NSString stringWithFormat:@"%@",error]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    
    #else
    
        // @"网络错误"
        NSString *commonUtils_alertUnExpectedError_release = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"commonUtils_alertUnExpectedError_release"];
        [CommonUtils ToastNotification:commonUtils_alertUnExpectedError_release andView:view andLoading:NO andIsBottom:NO];
    
    #endif
}

+ (NSString*)filterHtml:(NSString*)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html  =  [html  stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

+ (void)autoResizeViewByContent:(UILabel *)label width:(float)width content:(NSString*)content{
    //获得当前cell高度
//    CGRect frame = [label frame];
    //文本赋值
    label.text = content;
    //设置label的最大行数
    label.numberOfLines = 0;
    CGSize size = CGSizeMake(width, 1000);
    CGSize labelSize = [content sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, labelSize.width, labelSize.height);
}


+ (CGSize)getContentSize:(UIFont*) font content:(NSString*)content maxWidth:(float)maxWidth{
    CGSize size = CGSizeMake(maxWidth, 1000);
    CGSize labelSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize;
}

//用来获取uuid
+ (NSString*)uuid{
//    CFUUIDRef puuid = CFUUIDCreate( nil );
//    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
//    return result;
    return [[UIDevice currentDevice] uniqueAppInstanceIdentifier];
}


// imgUrl http->https
+ (NSString *)changeImageUrlStr:(NSString *)imgUrl {
    
    NSArray *httpArr = [imgUrl componentsSeparatedByString:@":"];
    
    if ([httpArr.firstObject isEqualToString:@"http"]) {
        
        imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    }
    
    return imgUrl;
}

+ (CGSize)returnLabelSize:(NSString *)text font:(UIFont *)font {

    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(kWidth, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

// 返回label Size
+ (CGSize)returnLabelSize:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)width {
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

// 返回label Size
+ (CGSize)returnLabelSizeAttributedString:(NSAttributedString *)attributedString font:(UIFont *)font labelWidth:(CGFloat)width {
    
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return size;
}

// 返回当前版本号
+ (NSString *)returnVersion {

    NSString *versin = [NSString stringWithFormat:@"%@(%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    return versin;
}


+ (void)saveDataWithKeyPath:(NSString *)path value:(id)data {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:path];
    [setting setObject:data forKey:path];
    [setting synchronize];
}

+ (id)getVualebyKeyPath:(NSString *)path {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:path];
}

/**首行缩进 2 字符*/
+ (NSAttributedString *)getAttributedString:(NSString *)string font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing{
    
    if (string == nil) {
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"  "];
        return attStr;
    }
    
    
    //    NSString *_test  =  @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    //        paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = lineSpacing ;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    return attrText;
}


/**首行缩进 2 字符*/
+ (NSAttributedString *)getTextViewAttributedString:(NSString *)string font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing{
    
    if (string == nil) {
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"  "];
        return attStr;
    }
    //    NSString *_test  =  @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = font.pointSize;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    //        paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = lineSpacing ;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    return attrText;
}


/** 获取字符串长度 **/
+ (NSInteger)getStringLenghtWithStr:(NSString *)str {

    NSInteger character = 0;
    for(int i=0; i< [str length];i++){
        unichar c = [str characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    return character;
}

@end
