//
//  DTRpcCommonInterceptor.m

#import "DTRpcCommonInterceptor.h"

@interface DTRpcCommonInterceptor ()

@property(nonatomic, strong) NSMutableArray *interceptorArray;

@end

@implementation DTRpcCommonInterceptor

- (id)init
{
	self = [super init];
	if (self)
    {
        NSMutableArray *interceptorList = [[NSMutableArray alloc]init];
        
        // create and add your interceptors to interceptorList here

        self.interceptorArray = interceptorList;
	}
	return self;
}

- (DTRpcOperation *)beforeRpcOperation:(DTRpcOperation *)operation
{
    DTRpcOperation *newOperation = operation;
    if (self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(beforeRpcOperation:)]) {
                newOperation = [interceptor beforeRpcOperation:newOperation];
            }
        }
    }
    
    return newOperation;
}

- (DTRpcOperation *)afterRpcOperation:(DTRpcOperation *)operation
{
    DTRpcOperation *newOperation = operation;
    if (self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(afterRpcOperation:)]) {
                newOperation = [interceptor afterRpcOperation:newOperation];
            }
        }
    }
    
    return newOperation;
}

- (void)handleException:(NSException *)exception
{
    if (self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(handleException:)]) {
                [interceptor handleException:exception];
            }
        }
    }
}

- (void)addRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor
{
    if (RPCInterceptor == nil) {
        return;
    }
    if (self.interceptorArray == nil) {
        self.interceptorArray = [[NSMutableArray alloc]init];
    }
    if ([self.interceptorArray indexOfObject:RPCInterceptor] == NSNotFound) {
        [self.interceptorArray addObject:RPCInterceptor];
    }
}

- (void)removeRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor
{
    if (RPCInterceptor == nil || self.interceptorArray == nil || [self.interceptorArray count] == 0) {
        return;
    }
    
    [self.interceptorArray removeObject:RPCInterceptor];
}

#pragma mark - Utils
- (NSArray*)interceptorList
{
    NSArray *arr = [[NSArray alloc] initWithArray:self.interceptorArray];
    return arr;
}

@end
