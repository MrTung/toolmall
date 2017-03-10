//
//  Status.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Status : BaseModel
@property int succeed;
@property int error_code;
@property(nonatomic,copy) NSString *error_desc;
@property(nonatomic,copy) NSString *success_desc;
//@property NSString *cartNum;

@end
