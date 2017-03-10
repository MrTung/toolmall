//
//  MsgDialogCell.h
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMessage.h"

@interface MsgDialogCell : UITableViewCell{
    UILabel *content;
    UILabel *nameandtime;
    UIImageView *bubbleImg;
}
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)setMessage:(AppMessage*)msg;
@end
