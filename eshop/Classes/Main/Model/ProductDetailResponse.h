//
//  ProductDetailResponse.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseModel.h"

@interface ProductDetailResponse : BaseModel

@property (nonatomic) Status * status;
@property (nonatomic) AppProduct *data;
@end
