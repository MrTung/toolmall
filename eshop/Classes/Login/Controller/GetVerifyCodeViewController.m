//
//  ShopLoginViewController.m
//  toolmall
//
//  Created by mc on 15/10/13.
//
//

#import "GetVerifyCodeViewController.h"

#define getImgUrl @"%@common/captcha.jhtm?captchaId=%@"

@interface GetVerifyCodeViewController ()

@property (nonatomic, strong) NSMutableString *codeMutString;

@property (nonatomic, strong) UIButton * btnLeft;
@property (nonatomic, strong) UIAlertView * alert;
@property (nonatomic, copy) NSString * captchaStr;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation GetVerifyCodeViewController

@synthesize txt_Name;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"获取验证码"
    NSString *getVerifyCode_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_navItem_title"];
    // 请输入用户名或手机号
    NSString *getVerifyCode_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_label_title"];
    [super addNavBackButton];
    [super addThreedotButton];
    [super addNavTitle:getVerifyCode_navItem_title];
    
    self.label.text = getVerifyCode_label_title;
    
//  页面布局
    [self UI];
    
//  添加手势，触摸文本框其他位置，键盘下去
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown)];
    [self.view addGestureRecognizer:clickGesture];
    
//  初始化验证码数组
//    _dataArray = [[NSArray alloc]initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    //  第一次的验证码
    //    [_codeLabel setText:[NSUUID ]];
    self.captchaStr = [[NSUUID UUID] UUIDString];
    [self getImgByCaptchaId:self.captchaStr];
    
    //  添加一个手势换验证码
    UITapGestureRecognizer * clickYView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeC:)];
    [self.yView addGestureRecognizer:clickYView];
    self.yView.userInteractionEnabled = YES;
    
    //  按钮更换验证码
    [self.btnExchangeCode addTarget:self action:@selector(exchangeC:) forControlEvents:UIControlEventTouchUpInside];
    [super addNavBackButton];

    checkCaptchaService = [[CheckCaptchaService alloc] initWithDelegate:self parentView:self.view];
    
}

//主要的布局
- (void)UI{
    
    // 用户名/邮箱/已验证手机
    NSString *getVerifyCode_txt_Name_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_txt_Name_plaTitle"];
    // 请输入验证码
    NSString *getVerifyCode_txt_Varify_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_txt_Varify_plaTitle"];
    // 获取短信验证码
    NSString *getVerifyCode_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_btn_title"];
//  用户名的左视图
    UIButton * btnUserLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    btnUserLeft.frame = CGRectMake(0, 0, 30, 30);
    btnUserLeft.tintColor = [UIColor whiteColor];
    [btnUserLeft setImage:[UIImage imageNamed:@"login_user.png"] forState:UIControlStateNormal];
    self.txt_Name.leftView = btnUserLeft;
    self.txt_Name.leftViewMode = UITextFieldViewModeAlways;
    self.txt_Name.placeholder = getVerifyCode_txt_Name_plaTitle;
    
    UIButton * btnPwdLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPwdLeft.frame = CGRectMake(0, 3, 15, 24);
    
    [btnPwdLeft setImage:[UIImage imageNamed:@"inputsmscode"] forState:UIControlStateNormal];
    self.txt_Varify.leftView = btnPwdLeft;
    self.txt_Varify.leftViewMode = UITextFieldViewModeAlways;
    self.txt_Varify.leftBlank = 5;
    self.txt_Varify.textBlank = 5;
    self.txt_Varify.delegate = self;
    self.txt_Varify.placeholder = getVerifyCode_txt_Varify_plaTitle;

    [self.btnLogin setTitle:getVerifyCode_btn_title forState:(UIControlStateNormal)];
    
//  给文本框添加颜色
    [self changeBorderColor];
    
}

#pragma 文本框框边颜色
- (void)changeBorderColor{
    
    UIColor * borderColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    
    _yView.layer.masksToBounds = YES;
    _yView.layer.cornerRadius = 5;
    _yView.layer.borderColor = borderColor.CGColor;
    _yView.layer.borderWidth = 1.0f;
    
    self.txt_Varify.layer.masksToBounds = YES;
    self.txt_Varify.layer.cornerRadius = 5;
    self.txt_Varify.layer.borderColor = borderColor.CGColor;
    self.txt_Varify.layer.borderWidth = 1.0f;
    
    self.txt_Name.layer.masksToBounds = YES;
    self.txt_Name.layer.cornerRadius = 5;
    self.txt_Name.layer.borderColor = borderColor.CGColor;
    self.txt_Name.layer.borderWidth = 1.0f;
    
    
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 5;
//    self.btnRegiste.layer.borderColor = [UIColor redColor].CGColor;
//    self.btnRegiste.layer.borderWidth = 1.0f;
}

//收了键盘
- (void)keybordDown{
    [self.txt_Name resignFirstResponder];
    [self.txt_Varify resignFirstResponder];
}

//换个验证码
- (void)exchangeC:(id)sender {
    //    _codeLabel.text = [self code];
    self.captchaStr = [[NSUUID UUID] UUIDString];
    [self getImgByCaptchaId:self.captchaStr];
}

//随机生成验证码
//- (NSString *)code{
//    _codeMutString = [[NSMutableString alloc]initWithCapacity:0];
//    verifyCode = @"";
//    for (int i=0; i<4; i++) {
//        NSInteger index = arc4random()%(_dataArray.count-1);
//        NSString * str = [NSString stringWithFormat:@" %@",[_dataArray objectAtIndex:index]];
//        _codeMutString = (NSMutableString *)[_codeMutString stringByAppendingString:str];
//        verifyCode = [verifyCode stringByAppendingString:[_dataArray objectAtIndex:index]];
//    }
//    return _codeMutString;
//}

//获取验证码
- (IBAction)click_Login:(id)sender
{
    if (![self.txt_Name.text isEqualToString: _user.name] && ![self.txt_Name.text isEqualToString: _user.mobile]) {
        
        // @"用户名或手机号错误"
        NSString *getVerifyCode_toastNotification_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"getVerifyCode_toastNotification_msg"];
        [CommonUtils ToastNotification:getVerifyCode_toastNotification_msg andView:self.view andLoading:YES andIsBottom:YES];
    }
    else{
        [checkCaptchaService chackImgByCaptchaId:self.captchaStr captcha:self.txt_Varify.text];
    }
    
}

//
- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    StatusResponse * respobj = (StatusResponse *)response;

    if (respobj.status.succeed) {
        VerifySecurityViewController * p = [[VerifySecurityViewController alloc] initWithNibName:@"VerifySecurityViewController" bundle:nil];
        p.user = _user;
        [self.navigationController pushViewController:p animated:YES];
    } else {
        [CommonUtils ToastNotification:respobj.status.error_desc andView:self.view andLoading:YES andIsBottom:YES];
    }
}

// 获取验证码
- (void)getImgByCaptchaId:(NSString *)captchaId {
    
    NSString *urlStr = [NSString stringWithFormat:getImgUrl, website_url, captchaId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *img = [UIImage imageWithData:data];
                
                self.codeImg.image = img;
            });
        }
    }];
    
    [dataTask resume];
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
