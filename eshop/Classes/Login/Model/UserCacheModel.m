//
//  UserCacheModel.m
//  eshop
//
//  Created by 董徐维 on 2017/3/7.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "UserCacheModel.h"
#import "SESSION.h"

@implementation UserCacheModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_couponCodeNum forKey:@"_couponCodeNum"];
    [aCoder encodeObject:_sid forKey:@"_sid"];
    [aCoder encodeObject:_key forKey:@"_key"];
    [aCoder encodeObject:_rank_name forKey:@"_rank_name"];
    [aCoder encodeObject:_email forKey:@"_email"];
    [aCoder encodeObject:_favoriteNum forKey:@"_favoriteNum"];
    [aCoder encodeObject:_gender forKey:@"_gender"];
    [aCoder encodeObject:_uid forKey:@"_uid"];
    [aCoder encodeObject:_isFirstOrder forKey:@"_isFirstOrder"];
    [aCoder encodeObject:_mobile forKey:@"_mobile"];
    [aCoder encodeObject:_name forKey:@"_name"];
    [aCoder encodeObject:_point forKey:@"_point"];
    [aCoder encodeObject:_rank_level forKey:@"_rank_level"];
    [aCoder encodeObject:_userNameChanged forKey:@"_userNameChanged"];
}

//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        _couponCodeNum = [aDecoder decodeObjectForKey:@"_couponCodeNum"];
        _rank_name = [aDecoder decodeObjectForKey:@"_rank_name"];
        _sid = [aDecoder decodeObjectForKey:@"_sid"];
        _key = [aDecoder decodeObjectForKey:@"_key"];
        _email = [aDecoder decodeObjectForKey:@"_email"];
        _favoriteNum = [aDecoder decodeObjectForKey:@"_favoriteNum"];
        _gender = [aDecoder decodeObjectForKey:@"_gender"];
        _uid = [aDecoder decodeObjectForKey:@"_uid"];
        _isFirstOrder = [aDecoder decodeObjectForKey:@"_isFirstOrder"];
        _mobile = [aDecoder decodeObjectForKey:@"_mobile"];
        _name = [aDecoder decodeObjectForKey:@"_name"];
        _point = [aDecoder decodeObjectForKey:@"_point"];
        _rank_level = [aDecoder decodeObjectForKey:@"_rank_level"];
        _userNameChanged = [aDecoder decodeObjectForKey:@"_userNameChanged"];
       
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    UserCacheModel *vo = [[[self class] allocWithZone:zone] init];
    vo.email = [self.email copyWithZone:zone];
    vo.rank_name = [self.rank_name copyWithZone:zone];
    vo.sid = [self.sid copyWithZone:zone];
    vo.key = [self.key copyWithZone:zone];
    vo.couponCodeNum = [self.couponCodeNum copyWithZone:zone];
    vo.favoriteNum = [self.favoriteNum copyWithZone:zone];
    vo.gender = [self.gender copyWithZone:zone];
    vo.uid = [self.uid copyWithZone:zone];
    vo.isFirstOrder = [self.isFirstOrder copyWithZone:zone];
    vo.mobile = [self.mobile copyWithZone:zone];
    vo.name = [self.name copyWithZone:zone];
    vo.point = [self.point copyWithZone:zone];
    vo.rank_level = [self.rank_level copyWithZone:zone];
    vo.userNameChanged = [self.userNameChanged copyWithZone:zone];
    return vo;
}


- (instancetype)initWithBaseModel:(UserSignInResponse *)baseModel
{
    self = [super init];
    if (self) {
        _couponCodeNum = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.couponCodeNum];
        _favoriteNum = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.favoriteNum];
        _gender = [[NSString alloc] initWithFormat:@"%@", baseModel.data.user.gender];
        _uid = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.id];
        _isFirstOrder = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.isFirstOrder];
        _mobile = [[NSString alloc] initWithFormat:@"%@", baseModel.data.user.mobile];
        _name = [[NSString alloc] initWithFormat:@"%@", baseModel.data.user.name];
        _point = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.point];
        _rank_level = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.rank_level];
        _userNameChanged = [[NSString alloc] initWithFormat:@"%d", baseModel.data.user.userNameChanged];
        _email = [[NSString alloc] initWithFormat:@"%@", baseModel.data.user.email];
        _rank_name = [[NSString alloc] initWithFormat:@"%@", baseModel.data.user.rank_name];
        
        _sid = [[NSString alloc] initWithFormat:@"%@", baseModel.data.session.sid];
        _key = [[NSString alloc] initWithFormat:@"%@", baseModel.data.session.key];

    }
    
    return self;
}

@end
