//
//  UserSignInResponse.m
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import "UserSignInResponse.h"

@implementation UserSignInResponse
@synthesize data;
@synthesize status;

+ (UserSignInResponse *) parseFromNSDictionary: (NSDictionary *) dic{
    UserSignInResponse * response = [UserSignInResponse alloc];
    Status * status = [Status alloc];
    status.succeed = [[dic objectForKey:@"status"] objectForKey:@"succeed"];
    response.status = status;
    return response;
}

- (void)convert:(NSDictionary*)dataSource
{
    for (NSString *key in [dataSource allKeys]) {
        if ([[self propertyKeys] containsObject:key]) {
            id propertyValue = [dataSource valueForKey:key];
            if (![propertyValue isKindOfClass:[NSNull class]]
                && propertyValue != nil) {
                [self setValue:propertyValue
                        forKey:key];
            }
        }
    }
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertys addObject:propertyName];
    }
    free(properties);
    return propertys;
}
@end
