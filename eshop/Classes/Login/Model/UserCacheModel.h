//
//  UserCacheModel.h
//  eshop
//
//  Created by 董徐维 on 2017/3/7.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCacheModel : NSObject

@property (nonatomic, copy) NSString *couponCodeNum;

@property (nonatomic, copy) NSString *favoriteNum;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *rank_name;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *isFirstOrder;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *point;

@property (nonatomic, copy) NSString *rank_level;

@property (nonatomic, copy) NSString *userNameChanged;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *key;

- (instancetype)initWithBaseModel:(UserSignInResponse *)baseModel;

@end
