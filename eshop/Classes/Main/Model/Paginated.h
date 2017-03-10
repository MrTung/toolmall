//
//  Paginated.h
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "BaseModel.h"

@interface Paginated : BaseModel
@property int total;
@property int more;
@property int count;
@end
