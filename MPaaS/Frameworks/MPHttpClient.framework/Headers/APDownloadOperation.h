//
//  APDownloadOperation.h
//  DTNetwork
//
//  Created by WenBi on 13-3-29.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import "DTURLRequestOperation.h"
#import "APDownloadRequest.h"


@interface APDownloadOperation : NSOperation

/** 下载成功后，文件所在路径。 */
@property(nonatomic, copy, readonly) NSString *path;

/** 下载中是否遇到错误。 */
@property(nonatomic, strong, readonly) NSError *error;

/** 下载的req**/
@property(nonatomic, strong, readonly) APDownloadRequest *downloadReq;

/**
 * 生成一个下载请求， 支持断点续传
 * @param aURL 请求URL
 * @param path 本地存储完全路径
 */

- (id)initWithFileAtURL:(NSURL *)aURL;

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

- (void)setProgressBlock:(void (^)(float percent, NSUInteger readBytes, NSUInteger totalBytes))block;


/**
 *  通过req方式初始化一个operation
 *
 *  @param downloadReq， 里面包含下载的url，completeBlock，progresBlock;
 */
-(id)initWithDownloadReq:(APDownloadRequest*)downloadReq;


/**
 *  取消下载连接
 */
-(void)cancel;


+ (NSString *)pathForURL:(NSURL *)aURL;

@end
