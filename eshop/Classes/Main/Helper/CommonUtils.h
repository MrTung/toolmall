//
//  CommonUtils.h
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "MBProgressHUD.h"
#import "ShopLoginViewController.h"

@interface CommonUtils : NSObject

+ (Boolean)chkLogin:(UIViewController*)controller gotoLoginScreen:(Boolean)gotoLoginScreen;
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view;
+ (NSString *)formatCurrency:(NSNumber *)number;
/** Label 展示不同大小字体|是否添加横划线*/
+ (NSMutableAttributedString *)getFormatCurrencyAttributedStringFromString:(NSString *)string isDelegate:(BOOL)isDelagate;

/** Label 展示不同大小字体 - 价格突出*/
+ (NSMutableAttributedString *)getProductPriceAttributedStringFromString:(NSString *)strin;

+ (NSString *) intToString:(int) intValue;
+ (void) fillIntToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(int)value;
+ (void) fillBooleanToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(Boolean)value;
+ (void) fillStrToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(NSString *)value;
+ (void) fillDicToDictionary:(NSMutableDictionary *)dictionary key:(NSString *)key value:(NSDictionary *)value;
+ (NSString*)ArrayToJson:(NSMutableArray *)obj;
+ (NSString *)DictionaryToJsonString:(NSDictionary*)dic;
+ (NSString *)formatDate:(NSDate*)date;
+ (NSString *)formatDateTime:(NSDate*)date;
+ (NSString *)changeDateFormatLineWithDot:(NSDate *)date;
+ (void) decrateGaryButton:(UIButton*)button;
+ (void) decrateRedButton:(UIButton*)button;

+ (void) decrateFullFillRedButton:(UIButton*)button title:(NSString*)title;
/** 给图片加边界 */
+ (void) decrateImageGaryBorder:(UIImageView*)image;
+ (void) decrateViewGaryBorder:(UIView*)view;
+ (void) setGaryBottomBorder:(UIView*)view;
+ (void) addGaryLine:(UIView*)view frame:(CGRect)frame;
+ (NSString*)trim:(NSString*)value;
+ (void) decrateViewCornerBorderAndShadow:(UIView*)view;
+ (void) setExtraCellLineHidden:(UITableView*)table;
//给字符串加上删除线
+ (NSAttributedString *)addDeleteLineOnLabel:(NSString *)string;
//给NSnumber加上删除线
+ (NSAttributedString *)addDeleteLineOnNumber:(NSNumber *)number;
+ (void) addBorderOnButton:(UIButton *)button;
+ (void) addBorderOnUITextField:(UITextField *)textField;
//13166668888 -> 131****8888
+ (NSString *)changeMobileNumberFormatter:(NSString *)string;

+ (void)displayNoResultView:(UIView*)view;
+ (void)displayNoResultView:(UIView*)view frame:(CGRect)frame;
+ (void)displayNoResultView:(UIView*)view frame:(CGRect)frame title:(NSString *)title;

+ (void)displayOrderNoResultView:(UIView*)view frame:(CGRect)frame;
+ (void)displayCollectionNoResultView:(UIView*)view frame:(CGRect)frame desc:(NSString *)desc;
+ (void)removeNoResultView:(UIView*)view;
+ (void) alertUnExpectedError:(NSError*)error view:(UIView*)view;

+ (NSString*)filterHtml:(NSString*)html;
+ (void)autoResizeViewByContent:(UILabel *)label width:(float)width content:(NSString*)content;

+ (CGSize)getContentSize:(UIFont*) font content:(NSString*)content maxWidth:(float)maxWidth;
+ (NSString*)uuid;

// imgUrl http->https
+ (NSString *)changeImageUrlStr:(NSString *)imgUrl;

// 返回label Size
+ (CGSize)returnLabelSize:(NSString *)text font:(UIFont *)font;
// 返回label Size
+ (CGSize)returnLabelSize:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)width;

+ (CGSize)returnLabelSizeAttributedString:(NSAttributedString *)attributedString font:(UIFont *)font labelWidth:(CGFloat)width;

// 返回当前版本号
+ (NSString *)returnVersion;

+ (void)saveDataWithKeyPath:(NSString *)path value:(id)data;

+ (id)getVualebyKeyPath:(NSString *)path;

/**首行缩进 2 字符 - Label*/
+ (NSAttributedString *)getAttributedString:(NSString *)string font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/**首行缩进 2 字符 - TextView*/
+ (NSAttributedString *)getTextViewAttributedString:(NSString *)string font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/** 获取字符串长度 **/
+ (NSInteger)getStringLenghtWithStr:(NSString *)str;

@end
