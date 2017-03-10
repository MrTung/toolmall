//
//  DTRpcCommonInterceptor.h

#import <Foundation/Foundation.h>

@interface DTRpcCommonInterceptor : NSObject <DTRpcInterceptor>

/**
 * 添加拦截器
 */
- (void)addRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor;

/**
 * 删除拦截器
 */
- (void)removeRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor;

/**
 * 返回当前的拦截器
 *
 *  @return 当前的拦截器列表
 */
- (NSArray*)interceptorList;

@end
