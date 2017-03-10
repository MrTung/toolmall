//
//  BaseModel.m
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import "BaseModel.h"

@implementation BaseModel

- (NSString *)toJsonString{
    NSDictionary * dic = [super toDictionary];

    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
@end
