//
//  MPJSONKit.h
//  MPJSONKit
//
//  Created by shenmo on 12/28/14.
//  Copyright (c) 2014 shenmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTNumber.h"

#pragma mark APJSONExtensions.h

@interface NSObject (APJSONKitExtensions)

- (NSString *)JSONString;

@end

@interface NSString (APJSONKitExtensions)

- (id)JSONValue;

@end

/**
 *  The data is Utf8 encoded json string
 */
@interface NSData (APJSONKitExtensions)

- (id)JSONValue;

@end

#pragma mark DTJsonDecoder.h

extern NSString * const NSClassCastExpcetion;

@interface DTJsonDecoder : NSObject

+ (DTJsonDecoder *)decoder;

- (id)decodeWithClass:(Class)cls elementClass:(Class)elementClass fromJSONString:(NSString *)string;
- (id)decodeWithClass:(Class)cls elementClass:(Class)elementClass fromJSONObject:(id)json;
- (id)decodeWithClassName:(NSString *)className elementClass:(Class)elementClass fromJSONObject:(id)json;

@end

#pragma mark DTJsonEncoder.h

@interface DTJsonEncoder : NSObject

/**
 * Creates and return a new <code>DTJsonEncoder</code> object.
 *
 * @return A newly created and initialized object of <code>DTJsonEncoder</code.
 */
+ (DTJsonEncoder *)encoder;

/**
 * Encodes a JSON object into a string with JSON format.
 *
 *
 */
- (NSString *)encodeObject:(id)object;

@end
