//
//  DTFileDownloadOperation.h
//  DTNetwork
//
//  Created by WenBi on 13-3-29.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "DTURLRequestOperation.h"

@interface DTDownloadOperation : DTURLRequestOperation

@property(nonatomic, strong) NSURL *sourceURL;
@property(nonatomic, strong) NSString *targetPath;
@property(nonatomic, assign) BOOL canOverwite;

/**
 * 生成一个下载请求， 支持断点续传
 * @param aURL 请求URL
 * @param path 本地存储完全路径
 */

- (id)initWithFileAtURL:(NSURL *)aURL toPath:(NSString *)path;

/**
 * 设置完成请求block
 * @param path 下载成功则path保存文件的路径返回
 * @param error 下载失败，error包含错误信息
 */

- (void)setCompletionBlock:(void (^)(NSString *path, NSError *error))block;

/**
 * 设置进度更新，可不设
 * @param percent 完成百分比[0, 100]
 * @param readBytes 已下载字节数
 * @param totalBytes 下载文件总大小
 */

- (void)setProgressBlock:(void (^)(CGFloat percent, NSUInteger readBytes, NSUInteger totalBytes))block;

@end
