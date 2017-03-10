//
//  MapResponse.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface MapResponse : BaseModel
{
    NSDictionary *dict;
}

- (Status*)getStatus;

@end
