//
//  IndexService.m
//  eshop
//
//  Created by mc on 16/3/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "IndexService.h"
#import "IndexResponse.h"

#import "InformationService.h"

@interface IndexService ()

@end
@implementation IndexService

- (void)getInfo{
    
    IndexResponse * resobj = [[IndexResponse alloc] init];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_index_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_index_list params:params responseObj: resobj];
}


- (void)getXMLString {
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_resource]];
    [client setDefaultHeader:@"If-Modified-Since" value:[[Config Instance] getUserInfo:@"Last-Modified"]];
    [client setDefaultHeader:@"If-None-Match" value:[[Config Instance] getUserInfo:@"Etag"]];

    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:api_xmlString parameters:nil];
    [request setCachePolicy:(NSURLRequestReloadIgnoringCacheData)];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        [[Config Instance] saveUserInfo:@"Last-Modified" withvalue:httpResponse.allHeaderFields[@"Last-Modified"]];
        [[Config Instance] saveUserInfo:@"Etag" withvalue:httpResponse.allHeaderFields[@"Etag"]];
        NSLog(@"statusCode == %@", @(httpResponse.statusCode));
        
        if (httpResponse.statusCode == 200) {
            
            if (self.delegate) {
                
                [self.delegate loadResponse:api_xmlString data:data];
            }
        }
    }];
    
    [dataTask resume];
    
}
@end
