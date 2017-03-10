//
//  TextDataBase.m
//  Test
//
//  Created by sh on 17/1/6.
//  Copyright © 2017年 sh. All rights reserved.
//

#import "TextDataBase.h"

//#import "FMDB.h"
#import <MPDataCenter/MPDataCenter.h>
#import "TextModel.h"
#import "ArrayModel.h"
#import "AppIndexUrl.h"

@interface TextDataBase ()

{
    BOOL isSuccess;
}
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation TextDataBase


/***
 *  创建单例接口
 */
static TextDataBase *single = nil;
+ (TextDataBase *)shareTextDataBase {
    
    @synchronized(self) {
        
        if (!single) {
            
            single = [[TextDataBase alloc] init];
            [single creatDataBase];
        }
    }
    return single;
}

#pragma mark - 创建数据库

- (void)creatDataBase {
    
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.sqlite"];
    
    NSLog(@"%@", dbPath);
    
    self.db = [FMDatabase databaseWithPath:dbPath];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [self.db open];
    
    // 创建 text 列表
    [self creatTextTable];
    
    // 创建 AppIndexUrl数组 列表
    [self creatAppIndexUrlNSMutableArrayTable];
    
    // 创建 AppMessage 列表
    [self creatAppMessageTable];
}

#pragma mark - text

/***
 *  创建 text 列表
 */
- (void)creatTextTable {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [self.db executeUpdate:@"create table if not exists Text(id integer primary key autoincrement, path text, textStr text)"];
        
        //    NSLog(@"%@", isSuccess ? @"Text 表格创建成功":@"Text 表格创建失败");
    }];
}

/***
 *  创建 text 保存接口
 */
- (void)saveTextModel:(TextModel *)textModel {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [self.db executeQuery:@"select *from Text where path = ?", textModel.path];
        if ([set next]) {
            
            NSString *valueStr = [set stringForColumn:@"textStr"];
            
            if (![valueStr isEqualToString:textModel.textStr]) {
                isSuccess = [self.db executeUpdate:[NSString stringWithFormat:@"update Text set textStr = '%@' where path = '%@'", textModel.textStr, textModel.path]];
                //            NSLog(@"textModel.path - %@", textModel.path);
                //            NSLog(@"%@", isSuccess ? @"Text 修改成功":@"Text 修改失败");
            }
        } else {
            
            isSuccess = [self.db executeUpdate:@"insert into Text(path, textStr) values (?, ?)", textModel.path, textModel.textStr];
            
            //        NSLog(@"textModel.path - %@", textModel.path);
            //        NSLog(@"%@", isSuccess ? @"Text 保存成功":@"Text 保存失败");
        }
        
    }];

}

/***
 *  根据 Path 查找 TextStr
 */
- (NSString *)searchTextStrByModelPath:(NSString *)path {
    
//    [self.queue inDatabase:^(FMDatabase *db) {
//        
//        
//    }];
    FMResultSet *set = [self.db executeQuery:@"select *from Text where path = ?", path];
    
    NSString *textStr;

    while ([set next]) {
        
        textStr = [set stringForColumn:@"textStr"];
        
//        NSLog(@"textStr - %@", textStr);
    }
    return textStr;
}


#pragma mark - AppIndexUrlNSMutableArray

/***
 *  创建 AppIndexUrlNSMutableArray 列表
 */
- (void)creatAppIndexUrlNSMutableArrayTable {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [self.db executeUpdate:@"create table if not exists AppIndexUrl(id integer primary key autoincrement, conesc text, coness text, newimage text, refId integer)"];
        
        //    NSLog(@"%@", isSuccess ? @"AppIndexUrlNSMutableArray 表格创建成功":@"AppIndexUrlNSMutableArray 表格创建失败");
    }];
}

/***
 *  创建 AppIndexUrlNSMutableArray 保存接口
 */

- (void)saveAppIndexUrlNSMutableArray:(NSMutableArray *)array {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        BOOL isChange = NO;
        for (AppIndexUrl *appIndexUrl in array) {
            
            FMResultSet *set = [self.db executeQuery:@"select *from AppIndexUrl where refId = ?", @(appIndexUrl.refId)];
            
            if (![set next]) {
                
                isChange = YES;
                break;
            }
        }
        if (isChange) {
            
            [self.db executeUpdate:@"delete from AppIndexUrl"];
            
            for (AppIndexUrl *appIndexUrl in array) {
                
                isSuccess = [self.db executeUpdate:@"insert into AppIndexUrl(conesc, coness, newimage, refId) values (?, ?, ?, ?)", appIndexUrl.conesc, appIndexUrl.coness, appIndexUrl.newimage, @(appIndexUrl.refId)];
                
                //            NSLog(@"textModel.path - %ld", appIndexUrl.refId);
                //            NSLog(@"%@", isSuccess ? @"AppIndexUrlNSMutableArray 保存成功":@"AppIndexUrlNSMutableArray 保存失败");
            }
        }
        
    }];
}


/***
 *  获取 AppIndexUrlNSMutableArray 所有数据
 */
- (NSMutableArray *)getAppIndexUrlNSMutableArray {

    FMResultSet *set = [self.db executeQuery:@"select *from AppIndexUrl"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *conesc = [set stringForColumn:@"conesc"];
        NSString *coness = [set stringForColumn:@"coness"];
        NSString *newimage = [set stringForColumn:@"newimage"];
        NSInteger refId = [set intForColumn:@"refId"];
        
        AppIndexUrl *model = [[AppIndexUrl alloc] init];
        
        model.conesc = conesc;
        model.coness = coness;
        model.newimage = newimage;
        model.refId = refId;
        
        [array addObject:model];
    }
    return array;
}

#pragma mark - AppMessage

/***
 *  创建 AppMessage 列表
 */
- (void)creatAppMessageTable {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [self.db executeUpdate:@"create table if not exists AppMessage(id integer primary key autoincrement, title text, content text, msgIP text)"];
        
        NSLog(@"%@", isSuccess ? @"AppMessage 表格创建成功":@"AppMessage 表格创建失败");
    }];
}

/***
 *  创建 AppMessage 保存接口
 */
- (void)saveAppMessage:(AppMessage *)msg {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        //    FMResultSet *set = [self.db executeQuery:@"select *from AppMessage where title = ?", msg.title];
        
        if (msg.title.length) {
            
            isSuccess = [self.db executeUpdate:@"insert into AppMessage(title, content, msgIP) values (?, ?, ?)", msg.title, msg.content, msg.ip];
            
            NSLog(@"title - %@", msg.title);
            NSLog(@"%@", isSuccess ? @"AppMessage 保存成功":@"AppMessage 保存失败");
        }
    }];
}

/***
 *  获取 AppMessage 所有数据
 */
- (NSMutableArray *)getAllAppMessageDataArr {
    
    FMResultSet *set = [self.db executeQuery:@"select *from AppMessage"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *title = [set stringForColumn:@"title"];
        NSString *content = [set stringForColumn:@"content"];
        NSString *msgIP = [set stringForColumn:@"msgIP"];
        
        AppMessage *model = [[AppMessage alloc] init];
        
        model.title = title;
        model.content = content;
        model.ip = msgIP;
        
        [array addObject:model];
    }
    return array;
}

/***
 *  删除 AppMessage 单条数据
 */
- (void)deleteOneAppMessageDataBy:(NSString *)msgTitle {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [self.db executeUpdate:@"delete from AppMessage where title = ?", msgTitle];
    }];
}

/***
 *  删除 AppMessage 所有数据
 */
- (void)deleteAllAppMessageDataArr {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [self.db executeUpdate:@"delete from AppMessage"];
    }];
}


@end
