//
//  NewMsg.h
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgService.h"
@interface NewMsg : UIViewController<ServiceResponselDelegate>{
    MsgService *msgService;
}

@property (nonatomic) IBOutlet UITextView *txtcontent;
@property (nonatomic) IBOutlet UITextField *txttitle;
@end
