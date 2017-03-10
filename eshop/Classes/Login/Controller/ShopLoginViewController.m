//
//  ShopLoginViewController.m
//  toolmall
//
//  Created by mc on 15/10/13.
//
//

#import "ShopLoginViewController.h"

#import "RegisteViewController.h"
#import "FirmMobileViewController.h"
#import "FindPasswordViewController.h"

#define getImgUrl @"%@common/captcha.jhtm?captchaId=%@"

@interface ShopLoginViewController ()

@property (nonatomic, strong) NSMutableString *codeMutString;
@property (nonatomic, strong) UIButton * btnLeft;
@property (nonatomic, strong) UIAlertView * alert;
@property (nonatomic, copy) NSString * captchaStr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout90;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayoutH8;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@end

@implementation ShopLoginViewController

@synthesize btnRegiste;
@synthesize btnForgetPsw;
@synthesize txt_Name;
@synthesize txt_Pwd;


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
    
    [self initView];
    
    [super addThreedotButton];
    
    [self loginGetImgByCaptchaId:self.captchaStr];
    
    [self refreshUI];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //添加一个手势换验证码
    UITapGestureRecognizer * clickYView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeC:)];
    [self.yView addGestureRecognizer:clickYView];
    self.yView.userInteractionEnabled = YES;
}

#pragma mark 收起键盘 edit by dxw 2017-03-07

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

-(void)initView{
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    
    // @"登录"
    NSString *shopLogin_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_navItem_title"];
    // @"忘记密码?"
    NSString *shopLogin_btnForgetPsw_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_btnForgetPsw_title"];
    // 登录
    NSString *shopLogin_btnLogin_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_btnLogin_title"];
    // 还没有帐号，免费注册
    NSString *shopLogin_btnRegiste_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_btnRegiste_title"];
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:shopLogin_btnForgetPsw_title attributes:attribtDic];
    
    [self.btnForgetPsw setAttributedTitle:attribtStr forState:(UIControlStateNormal)];
    
    self.btnForgetPsw.titleLabel.textColor = redColorSelf;
    
    //  创建导航
    [super addNavTitle:shopLogin_navItem_title];
    
    //页面布局
    [self.btnRegiste setTitleColor:redColorSelf forState:(UIControlStateNormal)];
    [self.btnRegiste setTitle:shopLogin_btnRegiste_title forState:(UIControlStateNormal)];
    
    self.btnLogin.backgroundColor = redColorSelf;
    [self.btnLogin setTitle:shopLogin_btnLogin_title forState:(UIControlStateNormal)];
    
    //  第一次的验证码
    self.captchaStr = [[NSUUID UUID] UUIDString];
    
    //  按钮更换验证码
    [self.btnExchangeCode addTarget:self action:@selector(exchangeC:) forControlEvents:UIControlEventTouchUpInside];
    [super addNavBackButton];
    loginService = [LoginService alloc];
    loginService.delegate = self;
    loginService.parentView = self.view;
}


- (void)refreshUI {
    
    // 用户名/邮箱/已验证手机
    NSString *shopLogin_txt_Name_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_txt_Name_plaTitle"];
    // 密码
    NSString *shopLogin_txt_Pwd_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_txt_Pwd_plaTitle"];
    // 请输入验证码
    NSString *shopLogin_txt_Varify_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_txt_Varify_plaTitle"];
    // 无需注册，直接登录
    NSString *shopLogin_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_label1_title"];
    // QQ登录
    NSString *shopLogin_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_label2_title"];
    // 微信登录
    NSString *shopLogin_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_label3_title"];
    
    self.txt_Name.placeholder = shopLogin_txt_Name_plaTitle;
    self.txt_Pwd.placeholder = shopLogin_txt_Pwd_plaTitle;
    self.txt_Varify.placeholder = shopLogin_txt_Varify_plaTitle;
    self.label1.text = shopLogin_label1_title;
    self.label2.text = shopLogin_label2_title;
    self.label3.text = shopLogin_label3_title;
    
    CGFloat height = TMScreenH-113;
    self.heightLayout90.constant = height*45.0/554;
    self.marginLayoutH1.constant = height*10.0/445;
    self.marginLayoutH2.constant = height*10.0/445;
    self.marginLayoutH3.constant = height*50.0/445;
    self.marginLayoutH4.constant = height*8.0/445;
    self.marginLayoutH5.constant = height*20.0/445;
    self.marginLayoutH6.constant = height*35.0/445;
    self.marginLayoutH7.constant = height*20.0/445;
    self.marginLayoutH8.constant = height*5.0/445;
    
    [self.view setNeedsUpdateConstraints];
}
#pragma Nav 导航

//是否显示密码明文
- (void)showPasswordOrNot:(UIButton *)button{
    self.txt_Pwd.secureTextEntry = !self.txt_Pwd.secureTextEntry;
    
}

#pragma mark - UUID

//换个验证码
- (void)exchangeC:(id)sender {
    
    self.captchaStr = [[NSUUID UUID] UUIDString];
    
    [self loginGetImgByCaptchaId:self.captchaStr];
}

- (IBAction)click_eyeBtn:(id)sender {
    
    txt_Pwd.secureTextEntry = !txt_Pwd.secureTextEntry;
    _eyeBtn.selected = !_eyeBtn.selected;
}

//点击登录按钮
- (IBAction)click_Login:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString *name = self.txt_Name.text;
    NSString *pwd = self.txt_Pwd.text;
    NSString *verCode = self.txt_Varify.text;
    
    // @"请输入用户名"
    NSString *shopLogin_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_toastNotification_msg1"];
    // @"请输入密码"
    NSString *shopLogin_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_toastNotification_msg2"];
    // @"请输入验证码"
    NSString *shopLogin_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shopLogin_toastNotification_msg3"];
    if (name.length == 0){
        [CommonUtils ToastNotification:shopLogin_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if (pwd.length == 0){
        [CommonUtils ToastNotification:shopLogin_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if (verCode.length == 0){
        [CommonUtils ToastNotification:shopLogin_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    
    [loginService loginWithName:name password:pwd captchaId:self.captchaStr captcha:verCode];
}

//注册账号
- (IBAction)click_registe:(id)sender{

    RegisteViewController * vc = [[RegisteViewController alloc]initWithNibName:@"RegisteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//找回密码
- (IBAction)click_forgetPsw:(id)sender{
    
    FindPasswordViewController *findPassword = [[FindPasswordViewController alloc] initWithNibName:@"FindPasswordViewController" bundle:nil];
    NSString *url = [api_host stringByAppendingString:@"password/find.jhtm?os=IOS"];
    findPassword.startPage = url;
    [self.navigationController pushViewController:findPassword animated:YES];
}

//第三方qq登录
- (IBAction)qqLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            self.openId = resp.openid;
            self.nickName = resp.name;
            self.accessToken = resp.accessToken;
            self.cartId = [SESSION getSession].cartId;
            
            [loginService loginWithWX:self.openId nickName:self.nickName cartId:self.cartId accessToken:self.accessToken];
        }
    }];
}

//第三方微信登录
- (IBAction)weixinLogin:(id)sender {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            
            NSLog(@"Wechat error %@", error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            self.openId = resp.openid;
            self.nickName = resp.name;
            self.accessToken = resp.accessToken;
            self.cartId = [SESSION getSession].cartId;
            
            [loginService loginWithWX:self.openId nickName:self.nickName cartId:self.cartId accessToken:self.accessToken];
        }
    }];
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    UserSignInResponse * respobj = (UserSignInResponse *)response;
    [[Config Instance] saveUserInfo:@"uid" withvalue:[[NSString alloc] initWithFormat:@"%d", respobj.data.user.id]];
    [[Config Instance] saveUserInfo:@"sid" withvalue:respobj.data.session.sid];
    [[Config Instance] saveUserInfo:@"uname" withvalue:respobj.data.user.name];
    [[Config Instance] saveUserInfo:@"key" withvalue:respobj.data.session.key];
    [[Config Instance] saveUserInfo:@"email" withvalue:respobj.data.user.email];
    [[Config Instance] saveUserInfo:@"memberrank" withvalue:respobj.data.user.rank_name];
    [[Config Instance] saveCartId:respobj.data.session.cartId];
    [[Config Instance] saveCartToken:respobj.data.session.cartToken];

    //保存用户信息
    [ArchiverCacheHelper saveObjectToLoacl:[[UserCacheModel alloc] initWithBaseModel:respobj] key:User_Archiver_Key filePath:User_Archiver_Path];
    
    //设置全局缓存信息
    [SharedAppUtil defaultCommonUtil].userCache = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];
    
    [SESSION setMobileNo:respobj.data.user.mobile];
    [SESSION setIsUserNameChanged:respobj.data.user.userNameChanged];
    
    [SESSION setSession:nil];

    if (!respobj.data.user.mobile) {
        
        FirmMobileViewController * firm = [[FirmMobileViewController alloc]initWithNibName:@"FirmMobileViewController" bundle:nil];
        [self.navigationController pushViewController:firm animated:YES];
    }
    else{
        
        if (_nextPageWhenLogined) {
            if ([_nextPageWhenLogined isEqualToString:@"msg"]) {
                MsgList * msg = [[MsgList alloc] initWithNibName:@"MsgList" bundle:nil];
                [self.navigationController pushViewController:msg  animated:YES];
                return;
            }else if ([_nextPageWhenLogined isEqualToString:@"favorite"]){
                FavoriteListController * msg = [[FavoriteListController alloc] initWithNibName:@"FavoriteListController" bundle:nil];
                [self.navigationController pushViewController:msg  animated:YES];
                return;
            }
        }
        else if (_popView) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


// 获取验证码
- (void)loginGetImgByCaptchaId:(NSString *)captchaId {
    
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


@end
