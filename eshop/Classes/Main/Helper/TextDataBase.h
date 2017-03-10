//
//  TextDataBase.h
//  Test
//
//  Created by sh on 17/1/6.
//  Copyright © 2017年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TextModel;
@class ArrayModel;
@class AppMessage;

@interface TextDataBase : NSObject

/***
 *  创建单例接口
 */
+ (TextDataBase *)shareTextDataBase;

#pragma mark - text

/***
 *  创建 text 列表
 */
- (void)creatTextTable;

/***
 *  创建 text 保存接口
 */
- (void)saveTextModel:(TextModel *)textModel;

/***
 *  根据 Path 查找 TextStr
 */
- (NSString *)searchTextStrByModelPath:(NSString *)path;


#pragma mark - AppIndexUrlNSMutableArray

/***
 *  创建 AppIndexUrlNSMutableArray 列表
 */
- (void)creatAppIndexUrlNSMutableArrayTable;

/***
 *  创建 AppIndexUrlNSMutableArray 保存接口
 */
- (void)saveAppIndexUrlNSMutableArray:(NSMutableArray *)array;

/***
 *  获取 AppIndexUrlNSMutableArray 所有数据
 */
- (NSMutableArray *)getAppIndexUrlNSMutableArray;


#pragma mark - AppMessage

/***
 *  创建 AppMessage 列表
 */
- (void)creatAppMessageTable;

/***
 *  创建 AppMessage 保存接口
 */
- (void)saveAppMessage:(AppMessage *)msg;

/***
 *  获取 AppMessage 所有数据
 */
- (NSMutableArray *)getAllAppMessageDataArr;

/***
 *  删除 AppMessage 单条数据
 */
- (void)deleteOneAppMessageDataBy:(NSString *)msgTitle;

/***
 *  删除 AppMessage 所有数据
 */
- (void)deleteAllAppMessageDataArr;




@end


