//
//  ProductCategoryListResponse.h
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import "BaseModel.h"
#import "AppProductCategory.h";
@interface ProductCategoryListResponse : BaseModel
@property NSString * parentId;
@property Status *status;
@property NSArray *data;
@property Paginated *paginated;

+ (Class)data_class;
@end
