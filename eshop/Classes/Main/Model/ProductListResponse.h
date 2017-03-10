//
//  ProductListResponse.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseModel.h"
#import "AppProduct.h"
#import "AppAttribute.h"
#import "Paginated.h"
@interface ProductListResponse : BaseModel
@property(nonatomic,strong) Status *status;
@property(nonatomic,strong) NSArray *data;
@property(nonatomic,strong) NSArray * attributes;
@property(nonatomic,strong) Paginated *paginated;

+ (Class)data_class;
+ (Class)attributes_class;
@end
