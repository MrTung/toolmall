//
//  AppProductImage.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseModel.h"

@interface AppProductImage : BaseModel
/** 原图片 */
@property NSString * source;

/** 大图片 */
@property NSString * large;

/** 中图片 */
@property NSString * medium;

/** 缩略图 */
@property NSString * thumbnail;

/** 排序 */
@property int order;
@end
