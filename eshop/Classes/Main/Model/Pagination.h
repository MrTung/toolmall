//
//  Pagination.h
//  toolmall
//
//  Created by mc on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface Pagination : Jastor
@property int count;
@property int page;

- (NSString *)toJsonString;
@end
