//
//  DynamicReleaseDefines.h
//  DynamicRelease
//
//  Created by ronghui.zrh on 16/3/5.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#ifndef DynamicReleaseDefines_h
#define DynamicReleaseDefines_h

#define kDynamicReleaseDomain @"com.alipay.dynamicrelease"

#define kDynamicReleaseError 299   //统一的错误

#define kDynamicReleaseRPCErrorCode  300 //服务端返回not success
#define kDynamicReleaseExceptionErrorCode  304   //异常
#define kDynamicReleaseContentNilErrorCode 305 //数据为nil
#define kDynamicReleaseContentMd5ErrorCode 306 //数据md5 error
#define kDynamicReleaseSaveFileErrorCode 307 // 保存资源文件错误                // 9.9.1开始只用于鸟巢
#define kDynamicReleaseSaveMetaInfoFileErrorCode 308 //保存metaInfo文件错误    // 9.9.1开始只用于鸟巢
#define kDynamicReleaseRemoveFileErrorCode 309 //remove资源文件和metainfo文件失败
#define kDynamicReleaseResourceTypeErrorCode 310 //资源类型错误

// 9.9.1新增

// 执行脚本阶段错误
#define kDynamicReleaseReadSigErrorCode 400 // 读取sig文件错误
#define kDynamicReleaseMD5MissingErrorCode 401 // 读取sig文件后检验md5，但在metainfo里没有md5
#define kDynamicReleaseVerifyMD5ErrorCode 402 // 读取sig文件后校验md5错误
#define kDynamicReleaseReadZipErrorCode 403 // 读取zip文件错误
#define kDynamicReleaseVerifySignErrorCode 404 // hotpatch签名验证错误
#define kDynamicReleaseHotpatchMissingErrorCode 405 // 执行hotpatch找不到资源文件

#define kDynamicReleaseJSRunErrorCodeBase 1000 // JSPatch那边的运行结果加上1000

// 处理脚本阶段错误
#define kDynamicReleaseSGInitializeErrorCode 500 // 无线保镖初始化失败
#define kDynamicReleaseSGEncryptErrorCode 501 // 无线保镖加密失败
#define kDynamicReleasePListSerializationErrorCode 502 // 将对象序列化失败
#define kDynamicReleaseProcessExceptionErrorCode 503 // 脚本处理阶段异常的错误
#define kDynamicReleaseWriteToDiskErrorCode 504 // 写文件阶段错误
#define kDynamicReleaseProcessUnknownErrorCode 505

static NSString * const DR_HOTPATCH = @"HOTPATCH";
static NSString * const DR_BIRDNEST = @"BIRDNEST";

static NSString * const DR_DYNAMICRELEASE = @"DynamicRelease";
static NSString * const DR_KEYBIZ = @"KeyBiz";
static NSString * const DR_VERSION = @"version";
static NSString * const DR_RESOURCEID = @"resId";
static NSString * const DR_METHOD_COUNT = @"methodCount";
static NSString * const DR_ERRORCODE = @"errorCode";
static NSString * const DR_ERRORDESC = @"errorDesc";
static NSString * const DR_BN_RES = @"resDesc";

static NSString * const DR_RPC_DYNAMICRELEASE = @"RPC_DynamicRelease";
static NSString * const DR_RPC_START = @"RPC_Start";
static NSString * const DR_RPC_FAIL = @"RPC_Fail";
static NSString * const DR_RPC_SUCCESS = @"RPC_Success";

static NSString * const DR_START = @"Start";
static NSString * const DR_DOWNLOAD_START = @"Download_Start";
static NSString * const DR_DOWNLOAD_SUCCESS = @"Download_Success";
static NSString * const DR_DOWNLOAD_FAILED = @"Download_Failed";
static NSString * const DR_PROCESS_START = @"Process_Start";
static NSString * const DR_SUCCESS = @"Success";
static NSString * const DR_FAIL = @"Fail";
static NSString * const DR_Exception_FAIL = @"Exception_Fail";
static NSString * const DR_EXIT_FOR_ROLLBACK = @"Exit_For_Rollback";

static NSString * const DR_EXECUTE_HOTPATCH_START = @"Execute_Hotpatch_Start";
static NSString * const DR_EXECUTE_HOTPATCH_FAILED = @"Execute_Hotpatch_Failed";
static NSString * const DR_EXECUTE_HOTPATCH_SUCCESS = @"Execute_Hotpatch_Success";

static NSString * const Rollback_Start = @"Rollback_Start";                  // RPC返回了结果，回滚链路开始
static NSString * const Rollback_Success = @"Rollback_Success";           // Rollback成功
static NSString * const Rollback_Fail = @"Rollback_Fail";                  // Rollback失败


static NSString * const DR_Verify_Start = @"Verify_Start";
static NSString * const DR_Verify_Success = @"Verify_Success";
static NSString * const DR_Verify_Failed = @"Verify_Failed";

static NSString * const DR_Biz_Notify_Start = @"Biz_Notify_Start";
static NSString * const DR_Biz_Notify_Failed = @"Biz_Notify_Failed";
static NSString * const DR_Biz_Notify_Success = @"Biz_Notify_Success";

#define DR_SAFE_STRING(s) ((s==nil)?@"":s)

#endif /* DynamicReleaseDefines_h */
