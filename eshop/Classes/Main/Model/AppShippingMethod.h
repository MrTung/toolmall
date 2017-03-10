
#import "BaseModel.h"

@interface AppShippingMethod : BaseModel

@property int id;
/** 名称 */
@property NSString* name;

/** 首重量 */
@property int firstWeight;

/** 续重量 */
@property int continueWeight;

/** 首重价格 */
@property NSNumber* firstPrice;

/** 续重价格 */
@property NSNumber* continuePrice;
@end
