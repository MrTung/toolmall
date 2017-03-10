//
//  MapResponse.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "MapResponse.h"

@implementation MapResponse

- (id)initWithDictionary:(NSDictionary *)dictionary {
    dict = dictionary;
    return dict;
}

- (Status*)getStatus{
    Status *status = [[Status alloc] init];
    if ([dict objectForKey:@"errCode"] != nil){
        status.error_code = [dict objectForKey:@"errCode"];
    }
    status.error_desc = [dict objectForKey:@"errDesc"];
    if (status.error_desc == nil){
        status.succeed = 1;
    } else{
        status.succeed = 0;
    }
    return status;
}
@end
