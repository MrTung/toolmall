//
//  MsgDialogCell.m
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "MsgDialogCell.h"
#import "AppMessage.h"
@implementation MsgDialogCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLayuot];
    }
    return self;
}
//初始化控件
-(void)initLayuot{
    bubbleImg = [[UIImageView alloc] init];
    [self addSubview:bubbleImg];

    
    content = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, self.frame.size.width - 50, 20)];
    content.font = [UIFont systemFontOfSize:13];
    [self addSubview:content];
    
    nameandtime = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 10, 50, 60, 30)];
    nameandtime.font = [UIFont systemFontOfSize:11];
    [nameandtime setTextColor:[UIColor darkGrayColor]];
    [self addSubview:nameandtime];
    
    }

- (void)setMessage:(AppMessage*)msg{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = 0;
    float height = 0;
    float nameandtimeWidth = 0;
    NSString *strNameAndTime = [[msg.senderName stringByAppendingString:@"  "] stringByAppendingString:[CommonUtils formatDateTime:msg.createDate]];
    if (msg.senderName == nil){
        strNameAndTime = [[@"管理员" stringByAppendingString:@"  "] stringByAppendingString:[CommonUtils formatDateTime:msg.createDate]];
    }
    nameandtime.text = strNameAndTime;
    [CommonUtils autoResizeViewByContent:content width:self.frame.size.width - 60 content:msg.content];
    [CommonUtils autoResizeViewByContent:nameandtime width:self.frame.size.width - 60 content:strNameAndTime];
    nameandtimeWidth = nameandtime.frame.size.width;
    width = content.frame.size.width;
    height = content.frame.size.height;
    if (width < nameandtimeWidth){
        width = nameandtimeWidth;
    }
    if (msg.senderName != nil){
        content.frame = CGRectMake(30, 12, width, height);
        bubbleImg.frame = CGRectMake(10, 6, width + 40, height + 40);
        bubbleImg.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        nameandtime.frame = CGRectMake(30, height + 18, 200, 20);
    } else {
        content.frame = CGRectMake(screenWidth - width - 30, 12, width, height);
        bubbleImg.frame = CGRectMake(screenWidth - width - 50, 6, width + 40, height + 40);
        bubbleImg.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        nameandtime.frame = CGRectMake(screenWidth - 230 , height + 18, 200, 20);
        [nameandtime setTextAlignment:NSTextAlignmentRight];
    }
    CGRect frame = [self frame];
    frame.size.height = height + 50;
    self.frame = frame;
}

@end
