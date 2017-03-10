//
//  AppProduct.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseModel.h"
#import "AppParameter.h"
#import "AppBrand.h"
#import "AppProductImage.h"
#import "AppGoods.h"
#import "AppPromotion.h"
#import "AppCoupon.h"

#import "SecondProductInfo.h"

@interface AppProduct : BaseModel

@property int id;
/** 编号 */
@property(nonatomic, strong) NSString * sn;

/** 名称 */
@property(nonatomic, strong) NSString * name;

/** 全称 */
@property(nonatomic, strong) NSString * fullName;

/** 销售价 */
@property(nonatomic, strong) NSNumber *price;

/** 促销价 */
@property(nonatomic, strong) NSNumber *promotionPrice;
@property(nonatomic, strong) NSString *pcMarking;
@property(nonatomic, strong) NSString *appMarking;

//运费
@property(nonatomic, strong) NSNumber *freight;

/** 市场价 */
@property(nonatomic, strong) NSNumber * marketPrice;

/** 展示图片 */
@property(nonatomic, strong) NSString * image;

/**
 * 购物车可分配库存
 */
@property(nonatomic, strong) NSString * availableStock;

/** 总库存 */
@property int stock;

/** 赠送积分 */
@property int point;

/** 评分 */
@property(nonatomic, strong) NSNumber *score;

/** 总评分 */
@property(nonatomic, strong) NSNumber * totalScore;

/** 评分数 */
@property(nonatomic, strong) NSString * scoreCount;


/** 销量 */
@property(nonatomic, strong) NSString * sales;

/** 周销量 */
@property(nonatomic, strong) NSString * weekSales;

/** 月销量 */
@property(nonatomic, strong) NSString * monthSales;


/** 制造商型号 **/
@property(nonatomic, strong) NSString * makerModel;

/**	商品简介 */
@property(nonatomic, strong) NSString * brief;

/* 商品规格 */
@property(nonatomic, strong) NSString * specificationName;


/**是否已收藏**/
@property Boolean isFavorited;

/**是否促销**/
@property Boolean isHotSale;

/**是否下架**/
@property Boolean isDeleted;

@property(nonatomic, strong) NSString *merchantName;

@property int merchantId;
@property BOOL isOffsale;

@property(nonatomic, strong) NSString *shopName;

@property(nonatomic, strong) NSString *shareUrl;

@property(nonatomic, strong) NSArray *appParameters;

@property(nonatomic, strong) NSArray *validPromotions;
@property(nonatomic, strong) NSArray *validCoupons;

/** 商品图片 */
@property(nonatomic, strong) NSArray *appProductImages;

@property(nonatomic, strong) AppBrand *appBrand;

@property(nonatomic, strong) AppGoods *appGoods;

/** 秒杀商品配置数据 */
@property(nonatomic, strong) SecondProductInfo *secondProductInfo;

+ (Class)appParameters_class;
+ (Class)appProductImages_class;
+ (Class)validPromotions_class;
+ (Class)validCoupons_class;
@end
