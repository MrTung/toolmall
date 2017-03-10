//
//  QRCodeUtils.m
//  eshop
//
//  Created by mc on 16/4/18.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "QRCodeUtils.h"

@implementation QRCodeUtils

+ (UIImage*) generateQRImage:(NSString*)content{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];

    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];

    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];

    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrFilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],nil];

    CIImage *qrImage = colorFilter.outputImage;

    //绘制
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRelease(cgImage);
    return codeImage;
}
@end
