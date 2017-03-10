//
//  MyInfoViewController.m
//  eshop
//
//  Created by mc on 16/4/11.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout90;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginHeight3;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5_title;
@property (weak, nonatomic) IBOutlet UILabel *label5_more;
@property (weak, nonatomic) IBOutlet UILabel *label6_title;
@property (weak, nonatomic) IBOutlet UILabel *label6_more;

@end

@implementation MyInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [super addNavBackButton];
    
    // @"我的资料"
    NSString *myInfoVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_navItem_title"];
    // 男
    NSString *myInfoVC_sexArray_index0 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index0"];
    // 女
    NSString *myInfoVC_sexArray_index1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index1"];
    // 保密
    NSString *myInfoVC_sexArray_index2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index2"];
    // @"拍照"
    NSString *myInfoVC_imageArray_index0 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_imageArray_index0"];
    // @"从相册中选择"
    NSString *myInfoVC_imageArray_index1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_imageArray_index1"];
    // @"取消"
    NSString *myInfoVC_imageArray_index2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_imageArray_index2"];
    // @"(当前版本号:%@)"
    NSString *myInfoVC_version_string = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_version_string"];
    // 退出登录
    NSString *myInfoVC_btnQuit_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_btnQuit_title"];
    [self setTextValue];
    
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = myInfoVC_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
    self.navigationController.navigationBarHidden = NO;
    userinfo = [[UserInfoService alloc] initWithDelegate:self parentView:self.view];
    _sexArray = [[NSArray alloc] init];
    _imageArray = [[NSArray alloc]init];
    _sexArray = @[myInfoVC_sexArray_index0, myInfoVC_sexArray_index1, myInfoVC_sexArray_index2];
    _imageArray = @[myInfoVC_imageArray_index0, myInfoVC_imageArray_index1, myInfoVC_imageArray_index2];

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.0;
    [self displayProfileImage];
    _lblUserName.text = _user.name;
    _lblSex.text = _user.gender;
    _lblBirthday.text = [CommonUtils formatDate:_user.birthday];
//    NSDateFormatter * datefor = [[NSDateFormatter alloc]init];
//    [datefor setDateFormat:@"yyyy-MM-dd"];
//    _lblBirthday.text = [datefor stringFromDate:_user.birthday];

    [self addThreedotButton];
    
    [self.btnQuit setTitle:myInfoVC_btnQuit_title forState:(UIControlStateNormal)];
    self.btnQuit.backgroundColor = redColorSelf;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *version = @"(当前版本号:%@)";
//    version = [[version stringByAppendingString:[infoDict objectForKey:@"CFBundleShortVersionString"]] stringByAppendingString:@")"];
    NSString * version = [NSString stringWithFormat:myInfoVC_version_string, [infoDict objectForKey:@"CFBundleShortVersionString"]];
    [self.lbVersionNO setText:version];
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.lbVersionNO.font forKey:NSFontAttributeName];
//    CGSize labSize = [@"关于手机土猫" sizeWithAttributes:dic];
//    
//    CGRect frame = self.lbVersionNO.frame;
//    frame.origin.x = labSize.width+12;
//    self.lbVersionNO.frame = frame;
    [self refreshUI];
}

- (void)refreshUI {

    CGFloat height = TMScreenH-113;
    self.heightLayout90.constant = height*45.0/554;
    self.marginHeight1.constant = height*15.0/554;
    self.marginHeight2.constant = height*15.0/554;
    self.marginHeight3.constant = height*50.0/554;
    
    [self.view needsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated{
    
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    if ([url isEqualToString:api_member_change_userfield]) {
        StatusResponse * respobj = (StatusResponse *)response;
        if (respobj.status.succeed == 1) {
            if ([_fieldName isEqualToString:@"gender"]) {
                _lblSex.text = _fieldValue;
//                进行本地配置
                [[Config Instance] saveUserInfo:@"gender" withvalue:_fieldValue];
                
            }else if ([_fieldName isEqualToString:@"birth"]){
                _lblBirthday.text = _fieldValue;
                [[Config Instance] saveUserInfo:@"birthday" withvalue:_fieldValue];
            }
        }
    }
}

//修改资料
- (IBAction)clickButtonToAlterUserInfo:(UIButton *)sender {
    
    int tag = (int)sender.tag;
    switch (tag) {
        case 1100:
            {
                //修改用户头像
                
                XWActionSheet * imageAS = [[XWActionSheet alloc] initWithTitleArray:_imageArray];
                [imageAS show];
                self.tabBarController.tabBar.hidden = YES;
                [imageAS setIdxBlock:^(NSInteger idx) {
                    if (idx == 0) {
                        
                        // Present the camera interface
                        ipc = [[UIImagePickerController alloc] init];
                        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                        ipc.delegate = self;
                        ipc.allowsImageEditing = YES; // allowsEditing in 3.1
                        [self presentModalViewController:ipc animated:YES];

                    }else if (idx == 1){
                        //获取本地相册
                        ipc = [[UIImagePickerController alloc] init];
                        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        ipc.delegate = self;
                        //设置选择后的图片可被编辑
                        ipc.allowsEditing = YES;
                        
                        [self presentModalViewController:ipc animated:YES];

                    }else{
                        
                    }
                }];
            }
            break;
        case 1101:
            {
                //修改用户名
                UserNameViewController * username = [[UserNameViewController alloc] initWithNibName:@"UserNameViewController" bundle:nil];
                username.user = _user;
                [self.navigationController pushViewController:username animated:YES];
            }
            break;
        case 1102:
            {
                
                // 男
                NSString *myInfoVC_sexArray_index0 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index0"];
                // 女
                NSString *myInfoVC_sexArray_index1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index1"];
                // 保密
                NSString *myInfoVC_sexArray_index2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_sexArray_index2"];
//                修改性别
                XWActionSheet * sexAS = [[XWActionSheet alloc] initWithTitleArray:_sexArray];
                [sexAS show];
                
                [sexAS setIdxBlock:^(NSInteger idx) {
                   _fieldValue = _sexArray[idx];
                    NSString * str = [[NSString alloc] init];
                    if ([_fieldValue isEqualToString:myInfoVC_sexArray_index0]) {
                        str = @"male";
                    }else if ([_fieldValue isEqualToString:myInfoVC_sexArray_index1]){
                        str = @"female";
                    }else if ([_fieldValue isEqualToString:myInfoVC_sexArray_index2]){
                        str = @"secrecy";
                    }
                    _fieldName = @"gender";
                    [userinfo userChangeUserFieldName:_fieldName fieldValue:str];
//                    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
                }];
                
            }
            break;
        case 1103:
            {
//                修改出生年月
                //x,y 值无效，默认是居中的
                KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - TMScreenW *40/320, TMScreenH *300/568)];
                picker.appearance.radius = 3;
                
                //设置回调
                picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
                    
                    if (buttonType == KSDatePickerButtonCommit) {
                        
                        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        _fieldValue = [formatter stringFromDate:currentDate];
                        _fieldName = @"birth";
                        [userinfo userChangeUserFieldName:_fieldName fieldValue:_fieldValue];
//                        [sender setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
                    }
                };
                // 显示
                [picker show];
            }
            break;
        case 1104:
            {
                //   账户安全
                AccountSecurityViewController * accountSecurity = [[AccountSecurityViewController alloc] initWithNibName:@"AccountSecurityViewController" bundle:nil];
                accountSecurity.user = _user;
                [self.navigationController pushViewController:accountSecurity animated:YES];

            }
            break;
        case 1105:
            {
                // @"关于土猫"
                NSString *myInfoVC_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_webView_navTitle"];
//                了解土猫
                MyWebView *myWebView = [[MyWebView alloc] init];
                myWebView.navTitle = myInfoVC_webView_navTitle;
                myWebView.loadUrl = url_about;
                [self.navigationController pushViewController:myWebView animated:YES];

            }
            break;
        default:
            break;
    }
}


//退出登录
- (IBAction)clickButtonToQuit:(UIButton *)sender {
    // 提示
    NSString *myInfoVC_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_alert_title"];
    // @"您确定要退出吗？"
    NSString *myInfoVC_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_alert_msg"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:myInfoVC_alert_title message:myInfoVC_alert_msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [SESSION setSession:nil];
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"uid"];
        [setting removeObjectForKey:@"sid"];
        [setting removeObjectForKey:@"uname"];
        [setting removeObjectForKey:@"key"];
        [setting removeObjectForKey:@"email"];
        [setting removeObjectForKey:@"memberrank"];
        [setting removeObjectForKey:@"cartToken"];
        [AppStatic setCART_ITEM_QUANTITIES:0];

        [self deleteheadimage];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        return;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo;
{
    // @"保存图片成功"
    NSString *myInfoVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_toastNotification_msg1"];
    // @"保存图片失败"
    NSString *myInfoVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_toastNotification_msg2"];
    // Handle the end of the image write process
    if (!error)
        [CommonUtils ToastNotification:myInfoVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
    else
        [CommonUtils ToastNotification:myInfoVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
}

-(NSString *)getImageSavePath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"/profilephoto.jpg"];
    return imageDocPath;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // Recover the snapped image
    UIImage *image = [self fixOrientation:[info
                                           objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    
    //保存
    NSString *imagePath = [self getImageSavePath];
    //以下是保存文件到Document路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data = nil;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    //保存
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
    

//    PictureEditViewController * pic = [[PictureEditViewController alloc] initWithNibName:@"PictureEditViewController" bundle:nil];
//    pic.picture.image = [UIImage imageWithContentsOfFile:imagePath];
//    [picker presentModalViewController:pic animated:NO];
    
        [self displayProfileImage];
          [self dismissModalViewControllerAnimated:YES];
        //上传用户头像
        [userinfo uploadHeadImage:image];
    
}

//- (void) imagePickerController:(UIImagePickerController *)picker
// didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//
//}


- (void)deleteheadimage{
    NSString *imagePath = [self getImageSavePath];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (image != nil){
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
}

- (void)displayProfileImage{
    NSString *imagePath = [self getImageSavePath];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (image != nil){
        _headImageView.image = image;
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;  
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 头像
    NSString *myInfoVC_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label1_title"];
    // 用户名
    NSString *myInfoVC_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label2_title"];
    // 性别
    NSString *myInfoVC_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label3_title"];
    // 出生年月
    NSString *myInfoVC_label4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label4_title"];
    // 账户安全
    NSString *myInfoVC_label5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label5_title"];
    // 可修改密码
    NSString *myInfoVC_label5_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label5_more"];
    // 关于手机土猫
    NSString *myInfoVC_label6_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label6_title"];
    // 查看
    NSString *myInfoVC_label6_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_label6_more"];
    
    // username
    NSString *myInfoVC_lblUserName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_lblUserName_title"];
    // sex
    NSString *myInfoVC_lblSex_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_lblSex_title"];
    // birthday
    NSString *myInfoVC_lblBirthday_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myInfoVC_lblBirthday_title"];
    
    self.label1.text = myInfoVC_label1_title;
    self.label2.text = myInfoVC_label2_title;
    self.label3.text = myInfoVC_label3_title;
    self.label4.text = myInfoVC_label4_title;
    self.label5_title.text = myInfoVC_label5_title;
    self.label5_more.text = myInfoVC_label5_more;
    self.label6_title.text = myInfoVC_label6_title;
    self.label6_more.text = myInfoVC_label6_more;
    
    _lblUserName.text = myInfoVC_lblUserName_title;
    _lblSex.text = myInfoVC_lblSex_title;
    _lblBirthday.text = myInfoVC_lblBirthday_title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
