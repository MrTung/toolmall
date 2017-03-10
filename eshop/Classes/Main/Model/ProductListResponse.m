//
//  ProductListResponse.m
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "ProductListResponse.h"

@implementation ProductListResponse
+ (Class)data_class{
    return [AppProduct class];
}

+ (Class)attributes_class{
    return [AppAttribute class];
}
@end
