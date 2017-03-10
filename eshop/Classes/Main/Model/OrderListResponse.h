//
//  OrderListResponse.h
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "BaseModel.h"
#import "Paginated.h"
#import "Status.h"
#import "AppOrderInfo.h"

@interface OrderListResponse : BaseModel
@property Status * status;
@property NSMutableArray * data;

@property Paginated * paginated;

+ (Class)data_class;
@end
