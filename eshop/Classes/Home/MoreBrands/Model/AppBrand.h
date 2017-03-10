//
//  AppBrand.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseModel.h"

@interface AppBrand : BaseModel

@property(nonatomic,assign) int id;

/** 名称 */
@property(nonatomic,copy) NSString * name;

/** logo */
@property(nonatomic,copy) NSString * logo;

/** 网址 */
@property(nonatomic,copy) NSString * url;
/** 简介 */
@property(nonatomic,copy) NSString * brief;


@end
