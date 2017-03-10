//
//  ProdImageScrollImage.h
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdImageScrollImage : UIViewController<UIScrollViewDelegate>{

    EGOImageView *_imageview;
    UIScrollView *_scrollview;
    
}
- (void)setImagePath:(NSString*)imagePath;
@end
