//
//  PromotionListCell.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionListCell : UITableViewCell

@property (nonatomic) IBOutlet EGOImageView *image;
@property (nonatomic) IBOutlet UILabel *prmoDesc;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)setBrief:(NSString*)brief;
- (void)setImageUrl:(NSString*)url;

@end
