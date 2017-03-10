//
//  ReviewService.m
//  eshop
//
//  Created by mc on 15/11/5.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "ReviewService.h"

@implementation ReviewService

- (void) getReviewList:(int)productId pagination:(Pagination*)pagination {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"productId" value:productId];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ReviewsResponse *respObj = [[ReviewsResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_review_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_review_list params:params responseObj:respObj];
    
}

- (void) submit:(NSMutableArray*)reviews isAnonymity:(Boolean)isAnonymity {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    ReviewSubmitRequest *request = [[ReviewSubmitRequest alloc] init];
    request.session = [SESSION getSession];
    request.reviews = reviews;
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillBooleanToDictionary:params key:@"isAnonymity" value:isAnonymity];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ReviewsResponse *respObj = [[ReviewsResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_review_submit];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_review_submit params:params responseObj:respObj];
}

@end
