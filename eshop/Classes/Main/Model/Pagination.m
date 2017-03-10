//
//  Pagination.m
//  toolmall
//
//  Created by mc on 15/10/13.
//
//

#import "Pagination.h"

@implementation Pagination
@synthesize count;
@synthesize page;

- (NSString *)toJsonString{
    NSDictionary * dic = [super toDictionary];
    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",count], @"count", [NSString stringWithFormat:@"%d",page], @"page", nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
