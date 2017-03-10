//
//  IndexResponse.m
//  eshop
//
//  Created by mc on 16/3/22.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "IndexResponse.h"

@implementation IndexResponse

+ (Class)greatBrands_class {
   
    return [AppIndexUrl class];
}

+ (Class)productCategories_class{
    
    return [AppIndexUrl class];
}

+ (Class)topAdvs_class{
    
    return [AppIndexUrl class];
}

+ (Class)shortcutLinks_class{
    
    return [AppIndexUrl class];
}

+ (Class)recommands_class{
    
    return [AppIndexUrl class];
}

+ (Class)hotActivities_class{
    
    return [AppIndexUrl class];
}


+ (Class)iOSShortcutLinks_class {
    
    return [AppIndexUrl class];
}


+ (Class)appparasetting_class {

    return [NSDictionary class];
}

+ (Class)hotActivityLogo_class {

    return [NSString class];
}

@end
