//
//  PicAndTextActionSheet.m
//  ActionSheetExtension
//
//  Created by yixiang on 15/7/6.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "PicAndTextActionSheet.h"
#import "ItemCell.h"

@interface PicAndTextActionSheet ()<UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , strong) NSArray *listData;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) UIView * customerView;
@property (nonatomic , strong) UIView * blankView;

@end

@implementation PicAndTextActionSheet

-(id) initWithList:(NSArray *)list title:(NSString *)title{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, sss);
        self.backgroundColor = RGBACOLOR(160, 160, 160, 0);
        
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  TMScreenH *40/568*[list count] +  TMScreenH *45/568) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSelectionStyleNone;
        
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.scrollEnabled = NO;
//        _tableview.layer.cornerRadius = 5;
        _tableview.tableFooterView = nil;
        
//        _blankView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_tableview.frame), ScreenWidth, 100)];
//        _blankView.backgroundColor = [UIColor whiteColor];
        
        UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_tableview.frame), ScreenWidth,  TMScreenH *44/568)];
        cancelLabel.layer.cornerRadius =0;
        cancelLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        // @"关闭"
        NSString *picAndTextActionSheet_cancelLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"picAndTextActionSheet_cancelLabel_title"];
        cancelLabel.text = picAndTextActionSheet_cancelLabel_title;
        cancelLabel.font = [UIFont boldSystemFontOfSize:20];
        cancelLabel.textAlignment = NSTextAlignmentCenter;
        cancelLabel.textColor = redColorSelf;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        cancelLabel.userInteractionEnabled = YES;
        [cancelLabel addGestureRecognizer:tapRecognizer];
    
        
        
        _customerView = [[UIView alloc] initWithFrame:CGRectMake( 0, sss, ScreenWidth, CGRectGetHeight(_tableview.frame) +  TMScreenH *44/568)];
        _customerView.backgroundColor = [UIColor clearColor];
        
        [_customerView addSubview:_tableview];
//        [_customerView addSubview:_blankView];
        [_customerView addSubview:cancelLabel];
        
        [self addSubview:_customerView];
        
        
        _listData = list;
        _title = title;
        
    }
    return self;
}

//如果tableview处于uiview上面，uiview整个背景有点击事件，但是我们需要如果我们点击tableview的时候，处理tableview的点击事件，而不是uiview的事件。在这里，我们需要判断我们点击事件是否在uiview上还是在uitableview上。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

-(void)animeData{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = RGBACOLOR(160, 160, 160, 0.4);
        CGRect originRect = _customerView.frame;
        
//        NSLog(@"----%d",sss);
//        NSLog(@"=====%d",CGRectGetHeight(_customerView.frame));

        originRect.origin.y = sss - (CGRectGetHeight(_customerView.frame)+64);
        _customerView.frame = originRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) tappedCancel{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        CGRect originRect = _customerView.frame;
        originRect.origin.y = sss;
        _customerView.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished) {
            for (UIView *v in _customerView.subviews) {
                [v removeFromSuperview];
            }
            [_customerView removeFromSuperview];
        }
    }];
}

- (void)  showInView:(UIViewController *)controller{
    
    if (controller) {
        [controller.view addSubview:self];
    }else{
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }
    [self animeData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listData count]+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  TMScreenH *45/568;
    }
    return  TMScreenH *40/568;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"TitleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,  TMScreenH *45/568-1, self.frame.size.width, 1)];
            lineView.backgroundColor = groupTableViewBackgroundColorSelf;
            [cell.contentView addSubview:lineView];
        }
        cell.textLabel.text = _title;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellIdentifier = @"DownSheetCell";
        ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[_listData objectAtIndex:indexPath.row-1]];
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tappedCancel];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [_delegate didSelectIndex:indexPath.row];
        return;
    }
}

@end
