//
//  CancelOrder.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CancelOrder.h"

@interface CancelOrder ()

@end

@implementation CancelOrder
@synthesize pickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        // @"取消理由"
        NSString *cancelOrder_picker_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_picker_title"];
        // @"完成"
        NSString *cancelOrder_picker_done = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_picker_done"];
        // @"不想买了"
        NSString *cancelOrder_pickerData_index0 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_pickerData_index0"];
        // @"尺寸错了"
        NSString *cancelOrder_pickerData_index1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_pickerData_index1"];
        // @"地址错了"
        NSString *cancelOrder_pickerData_index2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_pickerData_index2"];
        // @"其他"
        NSString *cancelOrder_pickerData_index3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cancelOrder_pickerData_index3"];
        self.title = cancelOrder_picker_title;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cancelOrder_picker_done style:UIBarButtonItemStylePlain target:self action:@selector(complete:)];
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 200);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
        pickerData = [NSArray arrayWithObjects:cancelOrder_pickerData_index0, cancelOrder_pickerData_index1, cancelOrder_pickerData_index2, cancelOrder_pickerData_index3, nil];
    }
    return self;
}

- (void)complete:(id)sender{
    int row = (int)[pickerView selectedRowInComponent:0];
    [_cancelOrderDelegate complete:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerData objectAtIndex:row];
}

@end
