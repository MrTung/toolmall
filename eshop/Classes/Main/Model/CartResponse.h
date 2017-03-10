//
//  CartResponse.h
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "BaseModel.h"
#import "AppCart.h"

@interface CartResponse : BaseModel

@property (nonatomic) Status * status;
@property (nonatomic) AppCart * data;
@end
