//
//  USER.h
//  toolmall
//
//  Created by mc on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "OrderNum.h"
@interface USER : BaseModel
@property(nonatomic,assign) int favoriteNum;
@property(nonatomic,assign) int couponCodeNum;
@property(nonatomic,assign) int id;
@property(nonatomic,assign) int rank_level;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *rank_name;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,strong) NSDecimalNumber *balanceAmt;
@property(nonatomic,strong) OrderNum *order_num;
@property(nonatomic,assign) int point;
@property(nonatomic,copy) NSString * mobile;
@property BOOL isFirstOrder;
@property BOOL userNameChanged;
@property(nonatomic,copy) NSString * gender;
@property(nonatomic, strong) NSDate * birthday;
@property (nonatomic, copy) NSString *price;

@end
