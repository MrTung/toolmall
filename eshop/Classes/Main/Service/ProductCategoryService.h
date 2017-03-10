//
//  ProductCategoryService.h
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import "BaseService.h"
#import "ProductCategoryListResponse.h"
@interface ProductCategoryService : BaseService
- (void) getRoots;
- (void) getRoots_v2;
- (void) getChildren:(NSString *)parentId;

@end
