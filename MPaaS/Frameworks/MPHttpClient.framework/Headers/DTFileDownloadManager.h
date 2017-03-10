//
//  DTFileDownloadManager.h
//  APMobileNetwork
//
//  Created by WenBi on 13-4-5.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 文件下载管理器。这个管理器维护一个文件下的队列和一个线程，用于执行 <code>DTFileDownloadOperation</code>。
 */
@interface DTFileDownloadManager : NSObject

/**
 * 启动一个下载请求
 * @param operation 一般为一个DTFileDownloadOperation对象
 */

- (void)addOperation:(NSOperation *)operation;

@end
