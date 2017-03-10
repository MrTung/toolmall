//
//  AppOrderItem.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppGiftItem.h"
@interface AppOrderItem : BaseModel
@property(nonatomic,assign) int id;
/** 商品编号 */
@property(nonatomic,copy) NSString* sn;
/** 商品名称 */
@property(nonatomic,copy) NSString* name;
/** 商品全称 */
@property(nonatomic,copy) NSString* fullName;
/**商品品牌名称**/
@property(nonatomic,copy) NSString* brandName;
/**商品制造商型号**/
@property(nonatomic,copy) NSString* makerModel;
/** 商品价格 */
@property(nonatomic,strong) NSNumber* price;
/** 商品重量 */
@property(nonatomic,assign) int weight;
/** 商品缩略图 */
@property(nonatomic,copy) NSString* thumbnail;
/** 是否为赠品 */
@property Boolean isGift;
/** 数量 */
@property(nonatomic,assign) int quantity;
/** 已发货数量 */
@property(nonatomic,assign) int shippedQuantity;
/** 已退货数量 */
@property(nonatomic,assign) int returnQuantity;
@property Boolean isReviewed;
@property Boolean displayPrice;

/** 商品 */
@property AppProduct* appProduct;
@property(nonatomic,assign) int merchantId;
@property(nonatomic,copy) NSString* merchantName; //商家
@property(nonatomic,strong) NSNumber * finalPrice; //折扣后价格
@property(nonatomic,strong) NSArray * giftItems; //赠品列表

+ (Class)giftItems_class;



@end
