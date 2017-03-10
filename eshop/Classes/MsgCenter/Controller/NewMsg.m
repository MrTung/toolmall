//
//  NewMsg.m
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "NewMsg.h"

@interface NewMsg ()

@end

@implementation NewMsg

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils decrateViewGaryBorder:self.txtcontent];
    [CommonUtils decrateViewGaryBorder:self.txttitle];
    
    msgService = [[MsgService alloc] initWithDelegate:self parentView:self.view];
    
}

- (IBAction)clickSend:(id)sender{
    NSString *title =[CommonUtils trim:self.txttitle.text];
    NSString *content = [CommonUtils trim:self.txtcontent.text];
    if (title.length == 0){
        [CommonUtils ToastNotification:@"请输入标题" andView:self.view andLoading:NO andIsBottom:NO];
        return;
        
    }
    if (content.length == 0){
        [CommonUtils ToastNotification:@"请输入内容" andView:self.view andLoading:NO andIsBottom:NO];
        return;
        
    }
    [msgService send:title content:content];
}

- (IBAction)clickBack :(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadResponse:(NSString *)url response:(BaseModel *)response{
    if ([url isEqualToString:api_msg_send]){
        StatusResponse *status = (StatusResponse*)response;
        if (status.status.succeed == 1){
            [CommonUtils ToastNotification:@"发送消息成功" andView:self.view andLoading:NO andIsBottom:NO];
            [self performSelector:@selector(clickBack:) withObject:nil afterDelay:2.0f];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
