//
//  AppProductCategory.h
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import "BaseModel.h"

@interface AppProductCategory : BaseModel
@property(nonatomic,assign) int id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *treePath;
@property(nonatomic,copy) NSString *grade;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) NSString *parentName;
@property(nonatomic,copy) NSString *subName;
@property(nonatomic,strong) NSArray *children;

+ (Class)children_class;
@end
