//
//  QRCodeUtils.h
//  eshop
//
//  Created by mc on 16/4/18.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeUtils : NSObject

+ (UIImage*) generateQRImage:(NSString*)content;
@end
