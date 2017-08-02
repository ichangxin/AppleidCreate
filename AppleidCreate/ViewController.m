//
//  ViewController.m
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/8.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import "ViewController.h"
#import "Questions.h"
#import "CXCreateRequest.h"
#import "AppleAccountVC.h"
#import "WYMailAccountVC.h"

#define Screen_W [[UIScreen mainScreen] bounds].size.width
#define Screen_H [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, retain) UITableView *answerTableView;
@property (nonatomic, retain) NSMutableArray    *question1Array;
@property (nonatomic, retain) NSMutableArray    *question2Array;
@property (nonatomic, retain) NSMutableArray    *question3Array;
@property (nonatomic, assign) NSUInteger       questionIndex;

@property (nonatomic, copy) NSString      *mailAddressStr;    //邮箱地址
@property (nonatomic, copy) NSString      *lastNameStr;        //姓氏
@property (nonatomic, copy) NSString      *firstNameStr;        //名字
@property (nonatomic, copy) NSString      *birthdayStr;        //生日
@property (nonatomic, copy) NSString      *countryStr;        //国家  CHN
@property (nonatomic, copy) NSString      *passwordStr;        //appleid密码

@property (nonatomic, copy) NSString      *question_id1Str;        //问题1的id
@property (nonatomic, copy) NSString      *question1Str;        //问题1
@property (nonatomic, copy) NSString      *answer1Str;         //答案1

@property (nonatomic, copy) NSString      *question_id2Str;        //问题2的id
@property (nonatomic, copy) NSString      *question2Str;        //问题2
@property (nonatomic, copy) NSString      *answer2Str;         //答案2

@property (nonatomic, copy) NSString      *question_id3Str;        //问题3的id
@property (nonatomic, copy) NSString      *question3Str;        //问题3
@property (nonatomic, copy) NSString      *answer3Str;         //答案3

@property (nonatomic, copy) NSString     *scntStr;           //scnt的值
@property (nonatomic, copy) NSString     *apiKeyStr;         //apiKey的值
@property (nonatomic, copy) NSString     *sessionIdStr;      //sessionId的值

@property (nonatomic, copy) NSString     *captchAnswer;      //打码图片的答案

@property (nonatomic, retain) UIWebView   *imageWebview;     //打码图片

@property (nonatomic, copy) NSString      *appleAccountID;     //注册的账号id

@property (nonatomic, assign) BOOL        isAppleIdUsed;       //该账号是否被使用 未使用：0，已使用：1
@property (nonatomic, assign) BOOL        isAppleIdValid;      //该账号是否合法  合法：1， 不合法：0
@property (nonatomic, assign) BOOL        appleOwnedDomain;    //是否是苹果自身的域名 苹果自身：1，不是苹果：0
@property (nonatomic, assign) BOOL        isRecycledDomain;    //是否是循环使用的域名 循环使用：1，未循环使用：0

@property (nonatomic, copy) NSString      *captchaTokenStr;   //打码图片返回的token
@property (nonatomic, copy) NSString      *captchaIdStr;      //打码图片返回的id

@property (nonatomic, assign) BOOL        applePdhasError;    //苹果账号密码有问题

@property (nonatomic, copy) NSString      *mailCodeStr;       //苹果发送的邮件验证码   answer

@property (nonatomic, copy) NSString      *verificationId;   //苹果服务器返回的邮箱验证码id


@property (nonatomic, assign) NSInteger     Distance_X;  //距离横坐标的距离
@property (nonatomic, assign) NSInteger     Distance_Y; //上下控件直接的间隔距离
@property (nonatomic, assign) NSInteger     Top_Distance_Y; //距离最顶端的距离
@property (nonatomic, assign) NSInteger     TF_Height; //文本框的高度
@property (nonatomic, assign) NSInteger     LB_Height; //标签的高度


@property (nonatomic, strong) UIButton       *checkAAccountBtn;           //查看苹果账号
@property (nonatomic, strong) UIButton       *checkWYAccountBtn;          //查看网易邮箱

@property (nonatomic, strong) NSArray       *mailAccountArray;           //邮箱账号

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateMyUIConfig];
    
    //iphone5:320 568 ---- iphone6:375  667 ----- iphone6 plus:414 736
    NSLog(@"手机屏幕的宽度：%.f",Screen_H);
    
    
    self.captchaImageView.image = [UIImage imageNamed:@"captcha.jpeg"];
    
    [self createAppleInfo];
    
    self.captchaImageView.userInteractionEnabled = YES;
    //给打码图片绑定刷新事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captchaRefresh)];
    [self.captchaImageView addGestureRecognizer:gesture];
    
    
    //请求账号信息
   // [self getAppleIDInfo];
    
}

#pragma mark -
#pragma mark UIControl控件大小更新
- (void)updateMyUIConfig{
    
    self.appleIdScroll.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.appleIdScroll.contentSize = CGSizeMake(Screen_W, Screen_H + 70);
    self.appleIdScroll.showsVerticalScrollIndicator = NO;
    //self.appleIdScroll.contentOffset = CGPointMake(0, 100);
    
    if (Screen_W == 320) {
        _Distance_X  =  10;    //距离横坐标的距离
        _Distance_Y  = 10;    //上下控件直接的间隔距离
        _Top_Distance_Y = 20;    //距离最顶端的距离
        _TF_Height = 30;    //文本框的高度
        _LB_Height = 20;    //标签的高度
    }else if (Screen_W == 375){
        _Distance_X  =  10;    //距离横坐标的距离
        _Distance_Y  = 13;    //上下控件直接的间隔距离
        _Top_Distance_Y = 20;    //距离最顶端的距离
        _TF_Height = 35;    //文本框的高度
        _LB_Height = 25;    //标签的高度
    }else if (Screen_W == 414){
        _Distance_X  =  10;    //距离横坐标的距离
        _Distance_Y  = 15;    //上下控件直接的间隔距离
        _Top_Distance_Y = 20;    //距离最顶端的距离
        _TF_Height = 38;    //文本框的高度
        _LB_Height = 28;    //标签的高度
    }
    
    //邮件地址和邮件文本框控件位置的安排
    self.mailLabel.frame = CGRectMake(_Distance_X, _Top_Distance_Y, 80, _LB_Height);
    self.mailField.frame = CGRectMake(self.mailLabel.frame.origin.x + self.mailLabel.frame.size.width + _Distance_X, _Top_Distance_Y -(_TF_Height - _LB_Height)/2 , Screen_W - self.mailLabel.frame.size.width - 3*_Distance_X, _TF_Height);
    
    self.mailField.returnKeyType = UIReturnKeyDone;
    self.mailField.delegate = self;
    self.mailField.tag = MailTextFieldTag;
    self.mailField.clearsOnBeginEditing = NO;
    self.mailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //姓氏控件位置的安排
    self.lastnameLabel.frame = CGRectMake(_Distance_X, _LB_Height + _Top_Distance_Y + _Distance_Y + (_TF_Height - _LB_Height)/2, 55, _LB_Height);
    self.lastnameField.frame = CGRectMake(self.lastnameLabel.frame.origin.x + self.lastnameLabel.frame.size.width + _Distance_X, _LB_Height + _Top_Distance_Y + _Distance_Y , Screen_W/2 - 2*_Distance_X - self.lastnameLabel.frame.size.width, _TF_Height);
    
    self.lastnameField.returnKeyType = UIReturnKeyDone;
    self.lastnameField.delegate = self;
    self.lastnameField.tag = LastNameFieldTag;
    self.lastnameField.clearsOnBeginEditing = NO;
    self.lastnameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //名字控件位置的安排
    self.firstnameLabel.frame = CGRectMake(Screen_W/2 + _Distance_X/2, _LB_Height + _Top_Distance_Y + _Distance_Y + (_TF_Height - _LB_Height)/2, 55, _LB_Height);
    self.firstnameField.frame = CGRectMake(self.firstnameLabel.frame.origin.x + self.firstnameLabel.frame.size.width + _Distance_X, _LB_Height + _Top_Distance_Y + _Distance_Y , Screen_W/2 - 2*_Distance_X - self.firstnameLabel.frame.size.width - _Distance_X/2, _TF_Height);
    
    self.firstnameField.returnKeyType = UIReturnKeyDone;
    self.firstnameField.delegate = self;
    self.firstnameField.tag = FirstNameFieldTag;
    self.firstnameField.clearsOnBeginEditing = NO;
    self.firstnameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //出生日期控件位置的安排
    self.birthdayLabel.frame = CGRectMake(_Distance_X, self.lastnameLabel.frame.origin.y + self.lastnameLabel.frame.size.height + _Distance_Y + (_TF_Height - _LB_Height)/2, 90, _LB_Height);
    self.birthdayField.frame = CGRectMake(self.birthdayLabel.frame.origin.x + self.birthdayLabel.frame.size.width + _Distance_X, self.lastnameLabel.frame.origin.y + self.lastnameLabel.frame.size.height + _Distance_Y , Screen_W - 2*_Distance_X - self.birthdayLabel.frame.size.width - _Distance_X, _TF_Height);
    
    self.birthdayField.returnKeyType = UIReturnKeyDone;
    self.birthdayField.delegate = self;
    self.birthdayField.tag = BirthdayFieldTag;
    self.birthdayField.clearsOnBeginEditing = NO;
    self.birthdayField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    //密码框控件位置的安排
    self.passwordLabel.frame = CGRectMake(_Distance_X, self.birthdayLabel.frame.origin.y + self.birthdayLabel.frame.size.height + _Distance_Y + (_TF_Height - _LB_Height)/2, 90, _LB_Height);
    self.passwordField.frame = CGRectMake(self.passwordLabel.frame.origin.x + self.passwordLabel.frame.size.width + _Distance_X, self.birthdayLabel.frame.origin.y + self.birthdayLabel.frame.size.height + _Distance_Y , Screen_W - 2*_Distance_X - self.passwordLabel.frame.size.width - _Distance_X, _TF_Height);
    
    self.pdShowBtn1.frame = CGRectMake(self.passwordField.frame.origin.x + self.passwordField.frame.size.width - 30, self.passwordField.frame.origin.y, _TF_Height, _TF_Height);
    
    
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.secureTextEntry = NO;
    self.passwordField.delegate = self;
    self.passwordField.tag = PasswordFieldTag;
    self.passwordField.clearsOnBeginEditing = NO;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    
    //问题1按钮控件位置的安排
    self.answer1Btn.frame = CGRectMake(_Distance_X*3, self.passwordField.frame.origin.y + self.passwordField.frame.size.height + _Distance_Y/2, Screen_W - 6*_Distance_X, _TF_Height);
    
    //问题1文本框位置的设置
    self.answer1Field.frame = CGRectMake(_Distance_X*2, self.answer1Btn.frame.origin.y + self.answer1Btn.frame.size.height + _Distance_Y/2, Screen_W - 4*_Distance_X, _TF_Height);
    
    self.answer1Field.returnKeyType = UIReturnKeyDone;
    self.answer1Field.delegate = self;
    self.answer1Field.tag = Answer1FieldTag;
    self.answer1Field.clearsOnBeginEditing = NO;
    self.answer1Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    //问题2按钮控件位置的安排
    self.answer2Btn.frame = CGRectMake(_Distance_X*3, self.answer1Field.frame.origin.y + self.answer1Field.frame.size.height + _Distance_Y/2, Screen_W - 6*_Distance_X, _TF_Height);
    
    //问题2文本框位置的设置
    self.answer2Field.frame = CGRectMake(_Distance_X*2, self.answer2Btn.frame.origin.y + self.answer2Btn.frame.size.height + _Distance_Y/2, Screen_W - 4*_Distance_X, _TF_Height);
    
    self.answer2Field.returnKeyType = UIReturnKeyDone;
    self.answer2Field.delegate = self;
    self.answer2Field.tag = Answer2FieldTag;
    self.answer2Field.clearsOnBeginEditing = NO;
    self.answer2Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //问题3按钮控件位置的安排
    self.answer3Btn.frame = CGRectMake(_Distance_X*3, self.answer2Field.frame.origin.y + self.answer2Field.frame.size.height + _Distance_Y/2, Screen_W - 6*_Distance_X, _TF_Height);
    
    //问题3文本框位置的设置
    self.answer3Field.frame = CGRectMake(_Distance_X*2, self.answer3Btn.frame.origin.y + self.answer3Btn.frame.size.height + _Distance_Y/2, Screen_W - 4*_Distance_X, _TF_Height);
    
    self.answer3Field.returnKeyType = UIReturnKeyDone;
    self.answer3Field.delegate = self;
    self.answer3Field.tag = Answer3FieldTag;
    self.answer3Field.clearsOnBeginEditing = NO;
    self.answer3Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //打码图片位置设置
    self.captchaImageView.frame = CGRectMake(_Distance_X, self.answer3Field.frame.origin.y + self.answer2Field.frame.size.height + _Distance_Y, 160*3/4, 90*3/4);
    //打码文本框位置设置
    self.captchaField.frame = CGRectMake( self.captchaImageView.frame.origin.x +self.captchaImageView.frame.size.width + _Distance_X, self.answer3Field.frame.origin.y + self.answer2Field.frame.size.height + 3*_Distance_Y, Screen_W - self.captchaImageView.frame.size.width - 4*_Distance_X, _TF_Height);
    
    self.captchaField.returnKeyType = UIReturnKeyDone;
    self.captchaField.delegate = self;
    self.captchaField.tag = CaptchaFieldTag;
    self.captchaField.clearsOnBeginEditing = NO;
    self.captchaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //初始化请求(创建账号页面)按钮
    self.createAccountBtn.frame = CGRectMake(_Distance_X, self.captchaImageView.frame.origin.y + self.captchaImageView.frame.size.height + _Distance_Y/2, 110, _TF_Height);
    
    //检验账号信息按钮
    self.checkAccountBtn.frame = CGRectMake(Screen_W - 110 - 2*_Distance_X, self.captchaImageView.frame.origin.y + self.captchaImageView.frame.size.height + _Distance_Y/2, 110, _TF_Height);
    
    //获取账号信息按钮
    self.receiveAccountBtn.frame = CGRectMake(_Distance_X, self.checkAccountBtn.frame.origin.y + self.checkAccountBtn.frame.size.height + _Distance_Y/2, 110, _TF_Height);
    
    //发送邮箱验证码按钮
    self.sendCodeBtn.frame = CGRectMake(Screen_W - 110 - 2*_Distance_X, self.checkAccountBtn.frame.origin.y + self.checkAccountBtn.frame.size.height + _Distance_Y/2, 110, _TF_Height);
    
    //邮箱验证码文本框按钮
    self.mailCodeField.frame = CGRectMake(Screen_W - 150 - 2*_Distance_X, self.sendCodeBtn.frame.origin.y + self.sendCodeBtn.frame.size.height + _Distance_Y/2, 150, _TF_Height);
    
    //接收验证码按钮
    self.receiveCodeBtn.frame = CGRectMake(Screen_W - 2*_Distance_X - 30, self.sendCodeBtn.frame.origin.y + self.sendCodeBtn.frame.size.height + _Distance_Y/2, _TF_Height, _TF_Height);
    
    self.mailCodeField.returnKeyType = UIReturnKeyDone;
    self.mailCodeField.delegate = self;
    self.mailCodeField.tag = MailCodeFieldTag;
    self.mailCodeField.clearsOnBeginEditing = NO;
    self.mailCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //发送邮箱验证码按钮
    self.submitAccountBtn.frame = CGRectMake((Screen_W - 110)/2, Screen_H - _TF_Height - 5, 110, _TF_Height);
    
    
    self.checkWYAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkWYAccountBtn.frame = CGRectMake((Screen_W - 100)/4, self.submitAccountBtn.frame.origin.y + self.submitAccountBtn.frame.size.height + _Distance_Y, 100, 30);
    [self.checkWYAccountBtn setTitle:@"查看邮箱账号" forState:UIControlStateNormal];
    self.checkWYAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.checkWYAccountBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.checkWYAccountBtn addTarget:self action:@selector(checkWYAccountClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.appleIdScroll addSubview:self.checkWYAccountBtn];
    
    self.checkAAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkAAccountBtn.frame = CGRectMake((Screen_W - 100)/2 + (Screen_W - 100)/4, self.submitAccountBtn.frame.origin.y + self.submitAccountBtn.frame.size.height + _Distance_Y, 100, 30);
    [self.checkAAccountBtn setTitle:@"查看苹果账号" forState:UIControlStateNormal];
    self.checkAAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.checkAAccountBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.checkAAccountBtn addTarget:self action:@selector(checkAAccountClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.appleIdScroll addSubview:self.checkAAccountBtn];
    
    
    //发送邮箱验证码按钮
    self.clearCookiesBtn.frame = CGRectMake(20, self.receiveAccountBtn.frame.origin.y + 35, 110, _TF_Height);
    
    
    
    self.answerTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, Screen_W - 40, Screen_H - 80) style:UITableViewStylePlain];
    self.answerTableView.dataSource = self;
    self.answerTableView.delegate = self;
    self.answerTableView.alpha = 0.8;
    [self.view addSubview:self.answerTableView];
    // [self.view bringSubviewToFront:self.answerTableView];
    self.answerTableView.hidden = YES;
}


#pragma mark -
#pragma mark 初始化AppleID账号的信息
//初始化apple账号信息  默认值(测试使用)
- (void)createAppleInfo{
    
    self.appleAccountID = @"111";
    self.mailAddressStr = @"Wsl4oEl8Pzkp@163.com";     //邮箱地址
    self.lastNameStr = @"满";        //姓氏
    self.firstNameStr = @"采梦";       //名字
    self.birthdayStr = @"1997-12-25";        //生日
    self.countryStr = @"CHN";         //国家  CHN
    self.passwordStr = @"Yt010689";        //账号密码
    
    self.question_id1Str = @"133";      //问题1的id
    self.question1Str = @"你第一次去电影院看的是哪一部电影？";        //问题1
    self.answer1Str = @"777";          //答案1
    
    self.question_id2Str = @"136";        //问题2的id
    self.question2Str = @"你小时候最喜欢哪一本书？";;        //问题2
    self.answer2Str = @"888";;         //答案2
    
    self.question_id3Str = @"144";;        //问题3的id
    self.question3Str  = @"您最喜欢哪个球队？";;        //问题3
    self.answer3Str = @"999";;         //答案3
    
    self.question1Array = [[NSMutableArray alloc] initWithCapacity:0];
    self.question2Array = [[NSMutableArray alloc] initWithCapacity:0];
    self.question3Array = [[NSMutableArray alloc] initWithCapacity:0];
    
    //{"code":"zh_TW","name":"繁體中文 - 中文（繁体）","enabled":true},{"code":"zh_HK","name":"繁體中文 - 中文（香港）","enabled":true}
    //id":130,"id":131,"id":132,"id":133,"id":134,"id":135,
    NSArray *questionsStr1 = [NSArray arrayWithObjects:@"你少年时代最好的朋友叫什么名字？",@"你的第一个宠物叫什么名字？",@"你学会做的第一道菜是什么？",@"你第一次去电影院看的是哪一部电影？",@"你第一次坐飞机是去哪里？",@"你上小学时最喜欢的老师姓什么？", nil];
    NSArray *idStrArray1 = [NSArray arrayWithObjects:@"130",@"131",@"132",@"133",@"134",@"135", nil];
    
    for (int i = 0;i < [questionsStr1 count]; i++) {
        Questions *question = [[Questions alloc] init];
        question.questionStr = [questionsStr1 objectAtIndex:i];
        question.idStr = [idStrArray1 objectAtIndex:i];
        [self.question1Array addObject:question];
    }
    
    NSArray *questionsStr2 = [NSArray arrayWithObjects:@"你的理想工作是什么？",@"你小时候最喜欢哪一本书？",@"你拥有的第一辆车是什么型号？",@"你童年时代的绰号是什么？",@"你在学生时代最喜欢哪个电影明星或角色？",@"你在学生时代最喜欢哪个歌手或乐队？", nil];
    NSArray *idStrArray2 = [NSArray arrayWithObjects:@"136",@"137",@"138",@"139",@"140",@"141", nil];
    
    for (int i = 0;i < [questionsStr2 count]; i++) {
        Questions *question = [[Questions alloc] init];
        question.questionStr = [questionsStr2 objectAtIndex:i];
        question.idStr = [idStrArray2 objectAtIndex:i];
        [self.question2Array addObject:question];
    }
    
    NSArray *questionsStr3 = [NSArray arrayWithObjects:@"你的父母是在哪里认识的？",@"你的第一个上司叫什么名字？",@"您从小长大的那条街叫什么？",@"你去过的第一个海滨浴场是哪一个？",@"你购买的第一张专辑是什么？",@"您最喜欢哪个球队？", nil];
    NSArray *idStrArray3 = [NSArray arrayWithObjects:@"142",@"143",@"144",@"145",@"146",@"147", nil];
    
    
    for (int i = 0;i < [questionsStr3 count]; i++) {
        Questions *question = [[Questions alloc] init];
        question.questionStr = [questionsStr3 objectAtIndex:i];
        question.idStr = [idStrArray3 objectAtIndex:i];
        [self.question3Array addObject:question];
    }
    
    self.mailField.text = self.mailAddressStr;
    self.lastnameField.text = self.lastNameStr;
    self.firstnameField.text = self.firstNameStr;
    self.passwordField.text = self.passwordStr;
    self.birthdayField.text = self.birthdayStr;
    [self.answer1Btn setTitle:self.question1Str forState:UIControlStateNormal];
    self.answer1Field.text = self.answer1Str;
    [self.answer2Btn setTitle:self.question2Str forState:UIControlStateNormal];
    self.answer2Field.text = self.answer2Str;
    [self.answer3Btn setTitle:self.question3Str forState:UIControlStateNormal];
    self.answer3Field.text = self.answer3Str;
    
    [self accountInfoRandom];
}


#pragma mark -
#pragma mark 账号信息本地随机生成
- (void)accountInfoRandom{
    [self readMailAccount];
    [self nameRandom];
    [self birthdayRandom];
   // [self passwordRandom];
    [self securityRandom];
}

#pragma mark -
#pragma mark 随机生成姓名
//随机生成姓名
- (void)nameRandom{
    
    //lastName生成
    NSString *lastNamePath=[[NSBundle mainBundle]pathForResource:@"姓氏" ofType:@"txt"];
    NSString *firstNamePath=[[NSBundle mainBundle]pathForResource:@"名字" ofType:@"txt"];
    ///编码可以解决 .txt 中文显示乱码问题
    NSStringEncoding *useEncodeing = nil;
    
    NSString *lastContents = [NSString stringWithContentsOfFile:lastNamePath usedEncoding:useEncodeing error:nil];
    NSString *firstContents = [NSString stringWithContentsOfFile:firstNamePath usedEncoding:useEncodeing error:nil];
    
    //NSLog(@"取出的值是：%@",txtContents);
    
    NSArray *lastNameArray = [lastContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *firstNameArray = [firstContents componentsSeparatedByString:@"、"];
    //NSArray *contentArray = [txtContents componentsSeparatedByString:@"、"];
    
    int lastIndex = (arc4random() % [lastNameArray count] - 1);
    int firstIndex = (arc4random() % [firstNameArray count] - 1);
    
//    //NSLog(@"输出的文件内容是：%@",contentArray);
//    for (NSString *contentStr in lastNameArray) {
//        NSLog(@"百家姓是：%@",contentStr);
//    }
    
    NSString *lastNameStr1 = [lastNameArray objectAtIndex:lastIndex];
    
    if (lastNameStr1.length == 0) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        
        NSInteger number = (randomH<<8)+randomL;
        
        NSData *data = [NSData dataWithBytes:&number length:2];
        
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        
        lastNameStr1 = string;
    }
    self.lastNameStr = lastNameStr1;
    self.firstNameStr = [firstNameArray objectAtIndex:firstIndex];
    
    self.lastnameField.text = self.lastNameStr;
    self.firstnameField.text = self.firstNameStr;
    
}

#pragma mark -
#pragma mark 出生日期随机生成
- (void)birthdayRandom{
    int yearDate = (arc4random() % 34 + 1970);
    int monthDate = (arc4random() % 12 + 1);
    int dayDate = 0;
    if (monthDate == 2) {
        dayDate = (arc4random() % 28 + 1);
    }else if (monthDate == 4 ||monthDate == 4 ||monthDate == 4 ||monthDate == 4){
        dayDate = (arc4random() % 30 + 1);
    }else{
        dayDate = (arc4random() % 31 + 1);
    }
    
    NSString *dateStr = @"";
    if (monthDate < 10) {
        if (dayDate < 10) {
            dateStr = [NSString stringWithFormat:@"%d-0%d-0%d",yearDate,monthDate,dayDate];
        }else{
            dateStr = [NSString stringWithFormat:@"%d-0%d-%d",yearDate,monthDate,dayDate];
        }
    }else{
        if (dayDate < 10) {
            dateStr = [NSString stringWithFormat:@"%d-%d-0%d",yearDate,monthDate,dayDate];
        }else{
            dateStr = [NSString stringWithFormat:@"%d-%d-%d",yearDate,monthDate,dayDate];
        }
    }

    NSLog(@"出生日期：%@",dateStr);
    
    self.birthdayStr = dateStr;
    self.birthdayField.text = self.birthdayStr;
}

#pragma mark -
#pragma mark 密码随机生成
- (void)passwordRandom{
    //至少有一个数字，至少有一个大写字母
    NSString *password = [[NSString alloc]init];
    for (int i = 0; i < 12; i++) {
       // int number = arc4random() % 36;
        //3数字  3大写字母 6小写字母
        //0，5，8放置大写字母
        if (i == 0 || i == 5 || i == 8) {
            int figure = (arc4random() % 26) + 97 - 32;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            password = [password stringByAppendingString:tempString];
        }else if ( i==3 || i== 6|| i == 7){  //3,6,7 放置数字
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            password = [password stringByAppendingString:tempString];
        }else{
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            password = [password stringByAppendingString:tempString];
        }
    }
    self.passwordStr = password;
    self.passwordField.text = self.passwordStr;
}

#pragma mark -
#pragma mark 安全问题随机生成
- (void)securityRandom{
    int answer1Index = arc4random()%6;
    Questions *question1 = [self.question1Array objectAtIndex:answer1Index];
    self.question_id1Str = question1.idStr;
    self.question1Str = question1.questionStr;
    [self.answer1Btn setTitle:self.question1Str forState:UIControlStateNormal];
    
    int answer2Index = arc4random()%6;
    Questions *question2 = [self.question2Array objectAtIndex:answer2Index];
    self.question_id2Str = question2.idStr;
    self.question2Str = question2.questionStr;
    [self.answer2Btn setTitle:self.question2Str forState:UIControlStateNormal];
    
    int answer3Index = arc4random()%6;
    Questions *question3 = [self.question3Array objectAtIndex:answer3Index];
    self.question_id3Str = question3.idStr;
    self.question3Str = question3.questionStr;
    [self.answer3Btn setTitle:self.question3Str forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark 查看网易邮箱账号
- (void)checkWYAccountClicked{

    WYMailAccountVC *wyMailAccount = [[WYMailAccountVC alloc] init];
    [self presentViewController:wyMailAccount animated:YES completion:nil];
    NSLog(@"查看网易邮箱账号");
}


#pragma mark -
#pragma mark 读取邮箱账号
- (void)readMailAccount{
    
    NSError *error = nil;
    NSString *readFileStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"邮箱账号" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    if (readFileStr == nil)
    {
        NSLog(@"出错了！%@",error);
    }
    //首要项目  以回车键进行数据的读取
    // self.functionArray = [readFileStr componentsSeparatedByString:@" "];
    self.mailAccountArray = [readFileStr componentsSeparatedByString:@"、"];
    
    static int accountIndex = 0;
    if (accountIndex >= [self.mailAccountArray count]) {
        accountIndex = 0;
    }
    NSString *accountStr = [self.mailAccountArray objectAtIndex:accountIndex];
    if (accountStr.length != 0) {
        NSArray *targetArray = [accountStr componentsSeparatedFromString:@"账号:" toString:@"---"];
        self.mailAddressStr = [targetArray objectAtIndex:0];
        self.mailField.text = self.mailAddressStr;
    }
    accountIndex++;
    NSLog(@"邮箱账号是：%lu",(unsigned long)accountIndex);
}



#pragma mark -
#pragma mark 查看苹果账号
- (void)checkAAccountClicked{
    
    AppleAccountVC *AAccount = [[AppleAccountVC alloc] init];
    [self presentViewController:AAccount animated:YES completion:nil];
    NSLog(@"查看苹果账号");
}


#pragma mark -
#pragma mark 清除cookies和app缓存
- (IBAction)clearCookiesClicked:(id)sender {
    NSURL *apmail_server_url = [NSURL URLWithString:@"https://appleid.apple.com"];
    if (apmail_server_url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:apmail_server_url];
        NSLog(@"苹果cookies是：%@",cookies);
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
    
    
    [ self showOkayCancelAlert];
}

- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"温馨提示", nil);
    NSString *message = [NSString stringWithFormat:@"当前缓存是%0.01fMB",[self folderSizeAtPath:[self getCachesPath]]];
    NSString *cancelButtonTitle = NSLocalizedString(@"暂不清除", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"立即清除", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        [self rightNowClearFiles];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



//获取缓存文件路径
-(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    //获取某个文件路径
    //  NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.nickcheng.NCMusicEngine"];
    
    return cachesDir;
    
}

//计算缓存文件的大小的M
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        
        
        //        //取得一个目录下得所有文件名
        
        //        NSArray *files = [manager subpathsAtPath:filePath];
        
        //        NSLog(@"files1111111%@ == %ld",files,files.count);
        
        //
        
        //        // 从路径中获得完整的文件名（带后缀）
        
        //        NSString *exe = [filePath lastPathComponent];
        
        //        NSLog(@"exeexe ====%@",exe);
        
        //
        
        //        // 获得文件名（不带后缀）
        
        //        exe = [exe stringByDeletingPathExtension];
        
        //
        
        //        // 获得文件名（不带后缀）
        
        //        NSString *exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        
        //        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);
        
        
        
        
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    
    
    return 0;
    
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        // NSLog(@"fileName ==== %@",fileName);
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        // NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    //NSLog(@"folderSize ==== %f",(float)folderSize/(1024.0*1024.0));
    
    return folderSize/(1024.0*1024.0);
    
}

//清除文件
- (void)rightNowClearFiles{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       //NSLog(@"files :%d",[files count]);
                       
                       for (NSString *p in files)
                       {
                           
                           NSError *error;
                           
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                           {
                               
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
}


//清除缓存成功
-(void)clearCacheSuccess
{
    //[MyTools PopMsg:@"清除成功" withTitle:@"提示"];
    [MyTools ToastNotification:@"缓存清理成功" andView:self.view andLoading:YES andIsBottom:YES];
}



#pragma mark -
#pragma mark 从自己的服务器获取注册账号的信息
- (void)getAppleIDInfo{
    [self accountInfoRandom];
    /*
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag)
    {
        //创建加载进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set some text to show the initial status.
        hud.label.text = NSLocalizedString(@"请求账号信息...", @"HUD preparing title");
        // Will look best, if we set a minimum size.
        hud.minSize = CGSizeMake(100.f, 50.f);
        
        //初始化appleid创建页面
        [CXCreateRequest cxrequestGetUrlAddress:QMGetAppleIdInfo_URL parameter:nil isQMUrl:YES requestSuccess:^(id responseObject, NSString *aStr) {
            //NSLog(@"获取到的结果是:%@",aStr);
            NSError *error;
            NSData  *data = [aStr dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary  *dictionaryFromJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingMutableLeaves
                                                                                         error:&error];
            //NSLog(@"获取到的值是：%@",dictionaryFromJson);
            NSDictionary *accountDic = [dictionaryFromJson objectForKey:@"account"];
            //保存每个账号的id，如果该账号注册成功，那么将成功的id，返回到我们自己的服务器进行保存。
            self.appleAccountID = [accountDic objectForKey:@"id"];
            self.mailAddressStr = [accountDic objectForKey:@"name"];
            self.passwordStr = [accountDic objectForKey:@"password"];
            
            NSDictionary *personDic = [accountDic objectForKey:@"person"];
            self.birthdayStr = [personDic objectForKey:@"birthday"];
            
            NSDictionary *nameDic = [personDic objectForKey:@"name"];
            //stringByRemovingPercentEncoding
            self.firstNameStr = [[nameDic objectForKey:@"firstName"] stringByRemovingPercentEncoding];
            self.lastNameStr = [[nameDic objectForKey:@"lastName"] stringByRemovingPercentEncoding];
            
            NSDictionary *primaryAddressDic = [personDic objectForKey:@"primaryAddress"];
            self.countryStr = [primaryAddressDic objectForKey:@"country"];
            
            NSDictionary *securityDic = [accountDic objectForKey:@"security"];
            NSArray *questionsArray = [securityDic objectForKey:@"questions"];
            NSDictionary *question1Dic = [questionsArray objectAtIndex:0];
            self.answer1Str = [question1Dic objectForKey:@"answer"];
            self.question_id1Str = [question1Dic objectForKey:@"id"];
            self.question1Str = [question1Dic objectForKey:@"question"];
            
            NSDictionary *question2Dic = [questionsArray objectAtIndex:1];
            self.answer2Str = [question2Dic objectForKey:@"answer"];
            self.question_id2Str = [question2Dic objectForKey:@"id"];
            self.question2Str = [question2Dic objectForKey:@"question"];
            
            NSDictionary *question3Dic = [questionsArray objectAtIndex:2];
            self.answer3Str = [question3Dic objectForKey:@"answer"];
            self.question_id3Str = [question3Dic objectForKey:@"id"];
            self.question3Str = [question3Dic objectForKey:@"question"];
            
            NSLog(@"苹果账号是：%@\n  姓氏：%@ \n  名字：%@\n 账号密码：%@ \n 国家：%@ \n 出生日期：%@ \n 问题1：%@----id1:%@----答案1：%@\n 问题2：%@----id2:%@----答案3：%@\n 问题3：%@----id3:%@----答案3：%@\n",self.mailAddressStr,self.lastNameStr,self.firstNameStr,self.passwordStr,self.countryStr,self.birthdayStr,self.question1Str,self.question_id1Str,self.answer1Str,self.question2Str,self.question_id2Str,self.answer2Str,self.question3Str,self.question_id3Str,self.answer3Str);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"得到了账号信息", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
                
                self.mailField.text = self.mailAddressStr;
                self.lastnameField.text = self.lastNameStr;
                self.firstnameField.text = self.firstNameStr;
                self.birthdayField.text = self.birthdayStr;
                self.passwordField.text = self.passwordStr;
                [self.answer1Btn setTitle:self.question1Str forState:UIControlStateNormal];
                self.answer1Field.text = self.answer1Str;
                [self.answer2Btn setTitle:self.question2Str forState:UIControlStateNormal];
                self.answer2Field.text = self.answer2Str;
                [self.answer3Btn setTitle:self.question3Str forState:UIControlStateNormal];
                self.answer3Field.text = self.answer3Str;
            });
        } requestFailure:^(id responseObject, NSError *error) {
            NSLog(@"错误信息是:%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"加载失败，请重新请求", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
            });
        }];
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
     */
}

#pragma mark -
#pragma mark 请求打码图片
//点击打码图片进行刷新请求
- (void)captchaRefresh{
    [self requestPicInfo];
}

#pragma mark -
#pragma mark 打码图片数据转换为图片信息显示
//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData1 = [[NSData alloc] initWithBase64EncodedString:_encodedImageStr options:0];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData1];
    return _decodedImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 安全问题1

- (IBAction)answer1BtnClicked:(id)sender {
    self.questionIndex = 1;
    [self.answerTableView setHidden:NO];
    [self.answerTableView reloadData];
    NSLog(@"问题1");
}

#pragma mark -
#pragma mark 安全问题2

- (IBAction)answer2BtnClicked:(id)sender {
    self.questionIndex = 2;
    [self.answerTableView setHidden:NO];
    [self.answerTableView reloadData];
    NSLog(@"问题2");
}

#pragma mark -
#pragma mark 安全问题3

- (IBAction)answer3BtnClicked:(id)sender {
    self.questionIndex = 3;
    [self.answerTableView setHidden:NO];
    [self.answerTableView reloadData];
    NSLog(@"问题3");
}

#pragma mark -
#pragma mark 请求初始化页面的接口（创建账号的页面）
- (IBAction)createCountClicked:(id)sender {
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        //创建加载进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set some text to show the initial status.
        hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
        // Will look best, if we set a minimum size.
        hud.minSize = CGSizeMake(100.f, 50.f);
        
        //初始化appleid创建页面
        [CXCreateRequest cxrequestGetUrlAddress:AppleCount_URL parameter:nil isQMUrl:NO requestSuccess:^(id responseObject, NSString *aStr) {
            //NSLog(@"获取到的结果是:%@",aStr);
            NSArray *targetArray = [aStr componentsSeparatedFromString:@"var bootData = {" toString:@"config: {"];
            NSString *targetStr = [targetArray objectAtIndex:0];
            NSArray *scntArray = [targetStr componentsSeparatedFromString:@"scnt: '" toString:@"',"];
            self.scntStr = [scntArray objectAtIndex:0];
            NSArray *apiKeyArray = [targetStr componentsSeparatedFromString:@"apiKey: '" toString:@"',"];
            self.apiKeyStr = [apiKeyArray objectAtIndex:0];
            NSArray *appleSessionIdArray = [targetStr componentsSeparatedFromString:@"sessionId: '" toString:@"',"];
            self.sessionIdStr = [appleSessionIdArray objectAtIndex:0];
            //[MyTools PopMsg:@"初始化请求成功，得到了scnt的值" withTitle:@"温馨提示"];
            // [MyTools PopMsg:@"初始化请求成功，得到了scnt的值" withTitle:@"温馨提示" viewController:self];
            NSLog(@"createCountClicked********截取到的scnt是：%@\n 截取到的apiKey是：%@\n 截取到的sessionId是：%@",_scntStr,_apiKeyStr,_sessionIdStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"得到scnt和sessionid", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
                
                //初始化成功以后，过三秒验证账号和密码。
                [self performSelector:@selector(validationAppleId) withObject:nil afterDelay:3];
            });
        } requestFailure:^(id responseObject, NSError *error) {
            NSLog(@"错误信息是:%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"加载失败，请重新请求", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
            });
        }];
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
    
    
//scnt: 'a42630ef5fe33b5db7d1b6cb8a1a2165',
//apiKey: 'cbf64fd6843ee630b463f358ea0b707b',     //公司网络和家里的网络都是同一个值。
//sessionId: '8B2C8ACB2D6EA87E3DDABDA57BF6FF44',
}

#pragma mark -
#pragma mark 从服务器请求账号信息

- (IBAction)receiveAccountInfo:(id)sender {
    [self getAppleIDInfo];
}

#pragma mark -
#pragma mark 提交账号信息进行校验
- (IBAction)validateAccountInfoClicked:(id)sender {
    [self validateAccountInfo];
}

#pragma mark -
#pragma mark 密码域

- (IBAction)pdShowBtnClicked1:(id)sender {
    if (self.passwordField.secureTextEntry) {
        [self.pdShowBtn1 setImage:[UIImage imageNamed:@"PasswordShow"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = NO;
    }else{
        [self.pdShowBtn1 setImage:[UIImage imageNamed:@"PasswordHidden"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = YES;
    }
}
#pragma mark -
#pragma mark 发送邮箱验证码请求
- (IBAction)sendMailCodeClicked:(id)sender {
    [self sendVerficationCode];
}

#pragma mark -
#pragma mark 提交账号信息并进行注册(这里是最后一步请求)
- (IBAction)submitRegisterAccountClicked:(id)sender {
    
    [self submitCodeRegisterAccount];
}

#pragma mark -
#pragma mark 从我们自己的服务器，收取苹果发送的邮件验证码。
- (IBAction)receiveCodeDDClicked:(id)sender {
    [self receiveDDMailCode];
}


#pragma mark -
#pragma mark 请求打码图片的接口
//请求打码图片信息
- (void)requestPicInfo{
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        //count请求到scnt值以后，才会进行打码图片的请求
        if (self.scntStr.length != 0) {
            NSDictionary* parameterDic = @{@"type":@"IMAGE"};
            
            //创建加载进度条
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set some text to show the initial status.
            hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
            // Will look best, if we set a minimum size.
            hud.minSize = CGSizeMake(100.f, 50.f);
            
            //parameter 没有值，设置为空字符串。
            [CXCreateRequest cxrequestPostUrlAddress:AppleCaptcha_URL
                                          httpMethod:@"POST"
                                       jsonParameter:parameterDic
                                           parameter:@""
                                                scnt:self.scntStr
                                              apiKey:self.apiKeyStr
                                           sessionId:self.sessionIdStr
                                      requestSuccess:^(id responseObject, NSDictionary *dict) {
                                          //NSLog(@"获取到的结果是:%@",dict);
                                          NSDictionary *payloadDic = [dict objectForKey:@"payload"];    //图片存放的字典
                                          NSString *captchaStr = [payloadDic objectForKey:@"content"];
                                          self.captchaIdStr = [dict objectForKey:@"id"];              //图片的id
                                          self.captchaTokenStr = [dict objectForKey:@"token"];            //图片的token
                                          NSLog(@"获取到的id是：%@\n    token是：%@\n  获取到的图片信息是：%@ ",self.captchaIdStr,self.captchaTokenStr,captchaStr);
                                          
                                          //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                          // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                          if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                              NSDictionary *dictionary = [httpResponse allHeaderFields];
                                              
                                              self.scntStr = [dictionary objectForKey:@"scnt"];
                                              
                                              NSLog(@"requestPicInfo*********新的scnt的值是：%@", self.scntStr);
                                              // NSLog(@"%@",dictionary);
                                              
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //这段代码要放到主线程中去执行，UI需要在主线程进行刷新显示。
                                              self.captchaImageView.image = [self Base64StrToUIImage:captchaStr];
                                              //创建加载进度完成提示
                                              MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                              UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                              hud.customView = imageView;
                                              hud.mode = MBProgressHUDModeCustomView;
                                              hud.label.text = NSLocalizedString(@"成功获得图片", @"HUD completed title");
                                              [hud hideAnimated:YES afterDelay:2.f];
                                          });
                                          
                                          // NSString *imageViewData = [NSString stringWithFormat:@"<img  src=\"data:image/jpeg;base64, %@\" width=\"120\" height=\"58\">",captchaStr];
                                          //self.imageWebview.hidden = NO;
                                          //[self.imageWebview loadHTMLString:imageViewData baseURL:nil];
                                          
                                      } requestFailure:^(id responseObject, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //创建加载进度完成提示
                                              MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                              UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                              hud.customView = imageView;
                                              hud.mode = MBProgressHUDModeCustomView;
                                              hud.label.text = NSLocalizedString(@"获取图片出错", @"HUD completed title");
                                              [hud hideAnimated:YES afterDelay:2.f];
                                          });
                                          NSLog(@"错误信息是:%@",error);
                                          
                                      }];
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
}

#pragma mark -
#pragma mark Appleid账号验证是否存在和合法
- (void)validationAppleId{
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.scntStr.length != 0) {
            //NSDictionary* parameterDic = @{@"":self.mailAddressStr};
            
            if (self.mailAddressStr.length == 0) {
                [MyTools ToastNotification:@"账号不能为空" andView:self.view andLoading:NO andIsBottom:NO];
                return;
            }
            
            //创建加载进度条
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set some text to show the initial status.
            hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
            // Will look best, if we set a minimum size.
            hud.minSize = CGSizeMake(100.f, 50.f);
            
            [CXCreateRequest cxrequestPostUrlAddress:AppleAppleId_URL
                                          httpMethod:@"POST"
                                       jsonParameter:nil
                                           parameter:self.mailAddressStr
                                                scnt:self.scntStr
                                              apiKey:self.apiKeyStr
                                           sessionId:self.sessionIdStr
                                      requestSuccess:^(id responseObject, NSDictionary *dict) {
                                          //NSLog(@"获取到的结果是:%@",dict);
                                          
                                          //该账号是否被使用 未使用：0，已使用：1
                                          self.isAppleIdUsed = [[dict objectForKey:@"used"] boolValue];
                                          //该账号是否合法  合法：1， 不合法：0
                                          self.isAppleIdValid = [[dict objectForKey:@"valid"] boolValue];
                                          //是否是苹果自身的域名 苹果自身：1，不是苹果：0
                                          self.appleOwnedDomain = [[dict objectForKey:@"appleOwnedDomain"] boolValue];
                                          //是否是循环使用的域名 循环使用：1，未循环使用：0
                                          self.isRecycledDomain = [[dict objectForKey:@"isRecycledDomain"] boolValue];
                                          
                                          NSLog(@"账号是否被使用：%d\n  账号是否合法：%d \n  是否是苹果域名：%d\n 是否循环使用的域名：%d \n",self.isAppleIdUsed,self.isAppleIdValid,self.appleOwnedDomain,self.isRecycledDomain);
                                          
                                          
                                          
                                          //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                          // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                          if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                              NSDictionary *dictionary = [httpResponse allHeaderFields];
                                              
                                              self.scntStr = [dictionary objectForKey:@"scnt"];
                                              
                                              NSLog(@"validationAppleId********新的scnt的值是：%@", self.scntStr);
                                              // NSLog(@"%@",dictionary);
                                              
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              
                                              [hud hideAnimated:YES];
                                              
                                              if (!self.isAppleIdUsed) {
                                                   [MyTools ToastNotification:@"账号可以使用" andView:self.view andLoading:NO andIsBottom:NO];
                                                  //账号验证通过以后，验证密码
                                                  [self performSelector:@selector(validatePassword) withObject:nil afterDelay:1];
                                              }
                                              
                                              if (self.isAppleIdUsed) {
                                                  [MyTools ToastNotification:@"该账号已经被使用，请更换账号" andView:self.view andLoading:NO andIsBottom:YES];
                                              }
                                              
                                              if (!self.isAppleIdValid) {
                                                  [MyTools ToastNotification:@"该账号不合法，请更换账号" andView:self.view andLoading:NO andIsBottom:YES];
                                              }
                                              
                                              if (self.isRecycledDomain) {
                                                  [MyTools ToastNotification:@"该域名循环使用，请更换域名" andView:self.view andLoading:NO andIsBottom:YES];
                                              }
                                          });
                                          
                                          
                                      } requestFailure:^(id responseObject, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //创建加载进度完成提示
                                              MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                              UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                              hud.customView = imageView;
                                              hud.mode = MBProgressHUDModeCustomView;
                                              hud.label.text = NSLocalizedString(@"验证失败", @"HUD completed title");
                                              [hud hideAnimated:YES afterDelay:2.f];
                                          });
                                          NSLog(@"错误信息是:%@",error);
                                          
                                      }];
        }else{
            [MyTools PopMsg:@"请先进行初始化请求，成功以后验证账号" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}
#pragma mark -
#pragma mark Appleid密码验证是否合法
- (void)validatePassword{
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.scntStr.length != 0) {
            NSDictionary* parameterDic = @{@"password":self.passwordStr};
            
            //创建加载进度条
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set some text to show the initial status.
            hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
            // Will look best, if we set a minimum size.
            hud.minSize = CGSizeMake(100.f, 50.f);
            
            //parameter 没有值，设置为空字符串。
            [CXCreateRequest cxrequestPostUrlAddress:ApplePassword_URL
                                          httpMethod:@"POST"
                                       jsonParameter:parameterDic
                                           parameter:@""
                                                scnt:self.scntStr
                                              apiKey:self.apiKeyStr
                                           sessionId:self.sessionIdStr
                                      requestSuccess:^(id responseObject, NSDictionary *dict) {
                                          //NSLog(@"获取到的结果是:%@",dict);
                                          if (dict != nil) {
                                              //密码有问题：1 密码没有问题：0
                                              self.applePdhasError = [[dict objectForKey:@"hasError"] boolValue];
                                              NSArray *errorsArray = [dict objectForKey:@"service_errors"];
                                              NSDictionary *errorsDic = [errorsArray objectAtIndex:0];
                                              //-21104
                                              int errorCode = [[errorsDic objectForKey:@"code"] intValue];
                                              NSString *errorMessage = [errorsDic objectForKey:@"message"];
                                              //密码太容易被猜到
                                              NSString *errorTitle = [errorsDic objectForKey:@"title"];
                                              
                                              NSLog(@"errorcode：%d   errorTitle：%@",errorCode,errorTitle);
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [hud hideAnimated:YES];
                                                  if (self.applePdhasError) {
                                                      [MyTools ToastNotification:errorMessage andView:self.view andLoading:NO andIsBottom:YES];
                                                  }
                                              });
                                              
                                          }else{ //没有错误，表示密码验证通过。
                                              NSLog(@"没有错误，密码验证通过");
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [hud hideAnimated:YES];
                                                  [MyTools ToastNotification:@"密码验证通过" andView:self.view andLoading:NO andIsBottom:YES];
                                              });
                                          }
                                          
                                          
                                          //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                          // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                          if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                              NSDictionary *dictionary = [httpResponse allHeaderFields];
                                              
                                              self.scntStr = [dictionary objectForKey:@"scnt"];
                                              
                                              NSLog(@"requestPicInfo*********新的scnt的值是：%@", self.scntStr);
                                              // NSLog(@"%@",dictionary);
                                              
                                          }
                                          
                                      } requestFailure:^(id responseObject, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //创建加载进度完成提示
                                              MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                              UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                              hud.customView = imageView;
                                              hud.mode = MBProgressHUDModeCustomView;
                                              hud.label.text = NSLocalizedString(@"密码验证出错", @"HUD completed title");
                                              [hud hideAnimated:YES afterDelay:2.f];
                                          });
                                          NSLog(@"错误信息是:%@",error);
                                          
                                      }];
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再验证密码" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}

#pragma mark -
#pragma mark 信息验证提交请求(点击最下方的“继续”按钮，提交所有的信息)
- (void)validateAccountInfo{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.captchAnswer.length == 0) {
            [MyTools ToastNotification:@"请填写图片验证码" andView:self.view andLoading:NO andIsBottom:YES];
        }
        //使用最新的scnt值
        if (self.scntStr.length != 0) {
            //需要先请求打码图片，才可以点击“继续”
            if (self.captchaTokenStr.length != 0) {
                NSDictionary *nameDic = @{@"firstName":self.firstNameStr,@"lastName":self.lastNameStr};
                
                NSDictionary *primaryAddressDic = @{@"country":self.countryStr};
                
                //person 字典
                NSDictionary *personDic = @{@"name":nameDic,@"birthday":self.birthdayStr,@"primaryAddress":primaryAddressDic};
                
                //这几个值写的都是固定的 preferences字典
                NSDictionary *marketPreDic = @{@"appleNews":@false,@"appleUpdates":@true,@"iTunesUpdates":@true};
                NSDictionary *preferencesDic = @{@"preferredLanguage":@"zh_CN",@"marketingPreferences":marketPreDic};
                
                //security字典  安全问题1，2，3
                NSDictionary *questionDic1 = @{@"id":self.question_id1Str,@"question":self.question1Str,@"answer":self.answer1Str};
                NSDictionary *questionDic2 = @{@"id":self.question_id2Str,@"question":self.question2Str,@"answer":self.answer2Str};
                NSDictionary *questionDic3 = @{@"id":self.question_id3Str,@"question":self.question3Str,@"answer":self.answer3Str};
                
                NSArray *questionsArray = [NSArray arrayWithObjects:questionDic1,questionDic2,questionDic3, nil];
                NSDictionary *securityDic = @{@"questions":questionsArray};
                
                NSDictionary *accountDic = @{@"name":self.mailAddressStr,@"password":self.passwordStr,@"password":self.passwordStr,@"person":personDic,@"preferences":preferencesDic,@"security":securityDic};
                
                //打码图片字典
                NSDictionary *captchaDic = @{@"id":self.captchaIdStr,@"token":self.captchaTokenStr,@"answer":self.captchaField.text};
                NSDictionary* parameterDic = @{@"account":accountDic,@"captcha":captchaDic};
                
                //创建加载进度条
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Set some text to show the initial status.
                hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
                // Will look best, if we set a minimum size.
                hud.minSize = CGSizeMake(100.f, 50.f);
                
                //parameter 没有值，设置为空字符串。
                [CXCreateRequest cxrequestPostUrlAddress:AppleValidate_URL
                                              httpMethod:@"POST"
                                           jsonParameter:parameterDic
                                               parameter:@""
                                                    scnt:self.scntStr
                                                  apiKey:self.apiKeyStr
                                               sessionId:self.sessionIdStr
                                          requestSuccess:^(id responseObject, NSDictionary *dict) {
                                              
                                              //NSLog(@"获取到的结果是:%@",dict);
                                              
                                              if (dict != nil) {
                                                  NSArray *validateErrorArray = [dict objectForKey:@"validationErrors"];
                                                  NSDictionary *errorDic = [validateErrorArray objectAtIndex:0];
                                                  NSString *errorCode = [errorDic objectForKey:@"code"];
                                                  NSString *errorMessage = [errorDic objectForKey:@"message"];
                                                  NSString *pathStr = [errorDic objectForKey:@"path"];
                                                  
                                                  NSLog(@"errorcode：%@   errorTitle：%@",errorCode,pathStr);
                                                  NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)responseObject;
                                                  if (httpResponse.statusCode == 400) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [hud hideAnimated:YES];
                                                          NSString *validateStr = [NSString stringWithFormat:@"%@并重刷！",errorMessage];
                                                          [MyTools ToastNotification:validateStr andView:self.view andLoading:NO andIsBottom:YES];
                                                      });
                                                  }
                                                  
                                                  
                                              }else{ //没有错误，表示账号信息验证通过。
                                                  NSLog(@"没有错误，账号验证通过！");
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      [MyTools ToastNotification:@"账号验证通过" andView:self.view andLoading:NO andIsBottom:YES];
                                                  });
                                              }
                                              
                                              
                                              //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                              // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                              if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                                  NSDictionary *dictionary = [httpResponse allHeaderFields];
                                                  
                                                  self.scntStr = [dictionary objectForKey:@"scnt"];
                                                  
                                                  NSLog(@"validateAccountInfo*********新的scnt的值是：%@", self.scntStr);
                                                  // NSLog(@"%@",dictionary);
                                                  
                                              }
                                              
                                          } requestFailure:^(id responseObject, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //创建加载进度完成提示
                                                  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                                  UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                                  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                                  hud.customView = imageView;
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.label.text = NSLocalizedString(@"验证账号信息出错", @"HUD completed title");
                                                  [hud hideAnimated:YES afterDelay:2.f];
                                              });
                                              NSLog(@"错误信息是:%@",error);
                                              
                                          }];
            }
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再验证密码" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
}

#pragma mark -
#pragma mark 发送邮箱验证码(提交账号和用户名，苹果服务器会返回验证码)
- (void)sendVerficationCode{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.captchAnswer.length == 0) {
            [MyTools ToastNotification:@"请填写图片验证码" andView:self.view andLoading:NO andIsBottom:YES];
        }
        //使用最新的scnt值
        if (self.scntStr.length != 0) {
            //点击请求继续，苹果会向该邮箱发送验证码
            if (self.captchaTokenStr.length != 0) {
                NSDictionary *nameDic = @{@"firstName":self.firstNameStr,@"lastName":self.lastNameStr};
                
                //person 字典
                NSDictionary *personDic = @{@"name":nameDic};
                
                
                NSDictionary *accountDic = @{@"name":self.mailAddressStr,@"person":personDic};
                
                NSDictionary* parameterDic = @{@"account":accountDic};
                
                //创建加载进度条
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Set some text to show the initial status.
                hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
                // Will look best, if we set a minimum size.
                hud.minSize = CGSizeMake(100.f, 50.f);
                
                //parameter 没有值，设置为空字符串。
                [CXCreateRequest cxrequestPostUrlAddress:AppleVerification_URL
                                              httpMethod:@"POST"
                                           jsonParameter:parameterDic
                                               parameter:@""
                                                    scnt:self.scntStr
                                                  apiKey:self.apiKeyStr
                                               sessionId:self.sessionIdStr
                                          requestSuccess:^(id responseObject, NSDictionary *dict) {
                                              
                                              //NSLog(@"获取到的结果是:%@",dict);
                                              
                                              if (dict != nil) {
                                                  
                                                  self.verificationId = [dict objectForKey:@"verificationId"];
                                                  //是否可以发送新的邮箱验证码  1代表可以发送，0代表不可以发送，可能超时了。
                                                  BOOL canGenerateNew = [[dict objectForKey:@"canGenerateNew"] boolValue];
                                                  NSInteger length = [[dict objectForKey:@"length"] integerValue];
                                                  
                                                  
                                                  NSLog(@"canGenerateNew：%d   length：%ld",canGenerateNew,(long)length);
                                                  NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)responseObject;
                                                  if (httpResponse.statusCode == 400) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [hud hideAnimated:YES];
                                                          
                                                          if (!canGenerateNew) {
                                                              [MyTools ToastNotification:@"请重新提交账号信息进行校验！" andView:self.view andLoading:NO andIsBottom:YES];
                                                          }
                                                      });
                                                  }else{
                                                      NSLog(@"邮箱验证码已经发送");
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [hud hideAnimated:YES];
                                                          [MyTools ToastNotification:@"邮箱验证码已发送" andView:self.view andLoading:NO andIsBottom:YES];
                                                      });
                                                  }
                                                  
                                                  
                                              }else{ //没有错误，表示账号信息验证通过。
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                  });
                                              }
                                              
                                              
                                              //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                              // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去使用
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                              if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                                  NSDictionary *dictionary = [httpResponse allHeaderFields];
                                                  
                                                  self.scntStr = [dictionary objectForKey:@"scnt"];
                                                  
                                                  NSLog(@"sendVerficationCode*********新的scnt的值是：%@", self.scntStr);
                                                  // NSLog(@"%@",dictionary);
                                                  
                                              }
                                              
                                          } requestFailure:^(id responseObject, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //创建加载进度完成提示
                                                  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                                  UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                                  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                                  hud.customView = imageView;
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.label.text = NSLocalizedString(@"验证邮箱出错", @"HUD completed title");
                                                  [hud hideAnimated:YES afterDelay:2.f];
                                              });
                                              NSLog(@"错误信息是:%@",error);
                                              
                                          }];
            }
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再验证" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}

#pragma mark - 
#pragma mark 验证邮箱验证码(通过苹果服务器发送的邮箱验证码，进行验证是否正确，如果验证正确，则无返回结果)
- (void)verficationCode{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.mailCodeStr.length == 0) {
            [MyTools ToastNotification:@"请填写邮箱验证码" andView:self.view andLoading:NO andIsBottom:YES];
        }
        //使用最新的scnt值
        if (self.scntStr.length != 0) {
            //点击请求继续，苹果会向该邮箱发送验证码
            if (self.captchaTokenStr.length != 0) {
                
                NSDictionary *verificationInfoDic = @{@"id":self.verificationId,@"answer":self.mailCodeStr};
                
                NSDictionary* parameterDic = @{@"name":self.mailAddressStr,@"verificationInfo":verificationInfoDic};
                
                //创建加载进度条
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Set some text to show the initial status.
                hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
                // Will look best, if we set a minimum size.
                hud.minSize = CGSizeMake(100.f, 50.f);
                
                //parameter 没有值，设置为空字符串。
                [CXCreateRequest cxrequestPostUrlAddress:AppleVerification_URL
                                              httpMethod:@"PUT"
                                           jsonParameter:parameterDic
                                               parameter:@""
                                                    scnt:self.scntStr
                                                  apiKey:self.apiKeyStr
                                               sessionId:self.sessionIdStr
                                          requestSuccess:^(id responseObject, NSDictionary *dict) {
                                              
                                              //NSLog(@"获取到的结果是:%@",dict);
                                              
                                              // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                              
                                              
                                              //如果状态码为400，说明提交的信息有错误
                                              if (httpResponse.statusCode == 400) {
                                                  NSArray *errorsArray = [dict objectForKey:@"service_errors"];
                                                  NSDictionary *errorsDic = [errorsArray objectAtIndex:0];
                                                  NSString *errorMessage = [errorsDic objectForKey:@"message"];
                                                  NSString *errorCode = [errorsDic objectForKey:@"code"];
                                                  //如果值为1，说明有错误
                                                  BOOL hasError = [[dict objectForKey:@"hasError"] boolValue];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      
                                                      if (hasError) {
                                                          [MyTools ToastNotification:errorMessage andView:self.view andLoading:NO andIsBottom:YES];
                                                      }
                                                  });
                                              }else if (httpResponse.statusCode == 204){  //204表示验证成功
                                                  NSLog(@"验证成功");
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      [MyTools ToastNotification:@"验证成功" andView:self.view andLoading:NO andIsBottom:YES];
                                                  });
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                  });
                                              }
                                              
                                              
                                              //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                              if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                                  NSDictionary *dictionary = [httpResponse allHeaderFields];
                                                  
                                                  self.scntStr = [dictionary objectForKey:@"scnt"];
                                                  
                                                  NSLog(@"verficationCode*********新的scnt的值是：%@", self.scntStr);
                                                  // NSLog(@"%@",dictionary);
                                                  
                                              }
                                              
                                          } requestFailure:^(id responseObject, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //创建加载进度完成提示
                                                  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                                  UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                                  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                                  hud.customView = imageView;
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.label.text = NSLocalizedString(@"请求邮箱验证出错", @"HUD completed title");
                                                  [hud hideAnimated:YES afterDelay:2.f];
                                              });
                                              NSLog(@"错误信息是:%@",error);
                                              
                                          }];
            }
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再验证" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
}

#pragma mark -
#pragma mark 输入验证码以后，进行验证账号信息(如果返回成功，表示账号注册成功)
- (void)submitCodeRegisterAccount{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        if (self.verificationId.length == 0) {
            [MyTools ToastNotification:@"请先进行账号验证" andView:self.view andLoading:NO andIsBottom:YES];
        }
        //使用最新的scnt值
        if (self.scntStr.length != 0) {
            //需要先请求打码图片，才可以点击“继续”
            if (self.captchaTokenStr.length != 0) {
                NSDictionary *nameDic = @{@"firstName":self.firstNameStr,@"lastName":self.lastNameStr};
                
                NSDictionary *primaryAddressDic = @{@"country":self.countryStr};
                
                //person 字典
                NSDictionary *personDic = @{@"name":nameDic,@"birthday":self.birthdayStr,@"primaryAddress":primaryAddressDic};
                
                //这几个值写的都是固定的 preferences字典
                NSDictionary *marketPreDic = @{@"appleNews":@false,@"appleUpdates":@true,@"iTunesUpdates":@true};
                NSDictionary *preferencesDic = @{@"preferredLanguage":@"zh_CN",@"marketingPreferences":marketPreDic};
                
                //security字典  安全问题1，2，3
                NSDictionary *questionDic1 = @{@"id":self.question_id1Str,@"question":self.question1Str,@"answer":self.answer1Str};
                NSDictionary *questionDic2 = @{@"id":self.question_id2Str,@"question":self.question2Str,@"answer":self.answer2Str};
                NSDictionary *questionDic3 = @{@"id":self.question_id3Str,@"question":self.question3Str,@"answer":self.answer3Str};
                
                NSArray *questionsArray = [NSArray arrayWithObjects:questionDic1,questionDic2,questionDic3, nil];
                NSDictionary *securityDic = @{@"questions":questionsArray};
                
                NSDictionary *verificationInfoDic = @{@"id":self.verificationId,@"answer":self.mailCodeStr};
                
                NSDictionary *accountDic = @{@"name":self.mailAddressStr,@"password":self.passwordStr,@"password":self.passwordStr,@"person":personDic,@"verificationInfo":verificationInfoDic,@"security":securityDic,@"preferences":preferencesDic};
                
                NSDictionary* parameterDic = @{@"account":accountDic};
                
                //创建加载进度条
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Set some text to show the initial status.
                hud.label.text = NSLocalizedString(@"加载中...", @"HUD preparing title");
                // Will look best, if we set a minimum size.
                hud.minSize = CGSizeMake(100.f, 50.f);
                
                //parameter 没有值，设置为空字符串。
                [CXCreateRequest cxrequestPostUrlAddress:AppleCount_URL
                                              httpMethod:@"POST"
                                           jsonParameter:parameterDic
                                               parameter:@""
                                                    scnt:self.scntStr
                                                  apiKey:self.apiKeyStr
                                               sessionId:self.sessionIdStr
                                          requestSuccess:^(id responseObject, NSDictionary *dict) {
                                              
                                              //NSLog(@"获取到的结果是:%@",dict);
                                              
                                              // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                                              
                                              
                                              //如果状态码为400，说明提交的信息有错误
                                              if (httpResponse.statusCode == 400) {
                                                  NSArray *errorsArray = [dict objectForKey:@"service_errors"];
                                                  NSDictionary *errorsDic = [errorsArray objectAtIndex:0];
                                                  NSString *errorMessage = [errorsDic objectForKey:@"message"];
                                                  NSString *errorCode = [errorsDic objectForKey:@"code"];
                                                  NSString *titleStr = [errorsDic objectForKey:@"title"];
                                                  //如果值为1，说明有错误
                                                  BOOL hasError = [[dict objectForKey:@"hasError"] boolValue];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      
                                                      if (hasError) {
                                                          [MyTools ToastNotification:[NSString stringWithFormat:@"%@%@",errorMessage,titleStr] andView:self.view andLoading:NO andIsBottom:YES];
                                                      }
                                                  });
                                              }else if (httpResponse.statusCode == 204){  //204表示验证成功
                                                  NSLog(@"验证成功");
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      [MyTools ToastNotification:@"验证成功" andView:self.view andLoading:NO andIsBottom:YES];
                                                  });
                                              }else if (httpResponse.statusCode == 201) //表示账号注册成功，苹果已经收录
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                      NSString *appleAccount = [dict objectForKey:@"name"];
                                                      NSLog(@"获取到的结果是:%@",dict);
                                                      NSString *messageStr = [NSString stringWithFormat:@"恭喜%@注册成功",appleAccount];
                                                      [MyTools ToastNotification:messageStr andView:self.view andLoading:NO andIsBottom:YES];
                                                      
                                                      //是否存在txt文件，如果不存在，就进行创建
                                                      if (![self isFileExist:@"AppleAccount.txt"]) {
                                                          NSString *str = @"";
                                                          //获取 document 路径
                                                          NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                                                          
                                                          //拼接上一个 txt 文件
                                                          NSString *filePath = [docPath stringByAppendingPathComponent:@"AppleAccount.txt"];
                                                          
                                                          //吧字符串写到 txt 文件
                                                          [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                                      }
                                                      
                                                      [self writeDataToFile];
                                                      
                                                      

                                                      //注册成功以后，将注册成功的id发送给服务器进行存储。 先不进行存储
                                                     // [self postSuccessAccount];
                                                      
                                                  });
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud hideAnimated:YES];
                                                  });
                                              }
                                              
                                              
                                              //点击刷新的时候，换成新的scnt的值。sessionid不变，
                                              if ([responseObject respondsToSelector:@selector(allHeaderFields)]) {
                                                  NSDictionary *dictionary = [httpResponse allHeaderFields];
                                                  
                                                  self.scntStr = [dictionary objectForKey:@"scnt"];
                                                  
                                                  NSLog(@"submitCodeRegisterAccount*********新的scnt的值是：%@", self.scntStr);
                                                  // NSLog(@"%@",dictionary);
                                                  
                                              }
                                              
                                          } requestFailure:^(id responseObject, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //创建加载进度完成提示
                                                  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                                  UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                                  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                                  hud.customView = imageView;
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.label.text = NSLocalizedString(@"注册账号出错", @"HUD completed title");
                                                  [hud hideAnimated:YES afterDelay:2.f];
                                              });
                                              NSLog(@"错误信息是:%@",error);
                                              
                                          }];
            }
        }else{
            //[MyTools PopMsg:@"请先进行初始化请求，成功以后再请求打码图片" withTitle:@"温馨提示"];
            [MyTools PopMsg:@"请先进行初始化请求，成功以后再注册账号" withTitle:@"温馨提示" viewController:self];
        }
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}

#pragma mark -
#pragma mark 判断沙盒中是否存在txt文件
//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

#pragma mark -
#pragma mark 创建txt文件，并在文件中写入数据
- (void)writeDataToFile{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filenamePath=[path stringByAppendingPathComponent:@"AppleAccount.txt"];   //获取路径
    
    //混淆字符串结果
    NSString *readAppleIDStr=[[NSMutableString alloc] initWithString:@""];
    
    ///编码可以解决 .txt 中文显示乱码问题
    NSStringEncoding *useEncodeing = nil;
    
    
    readAppleIDStr = [NSString stringWithContentsOfFile:filenamePath usedEncoding:useEncodeing error:nil];

    
    if (readAppleIDStr.length == 0) {
        NSLog(@"还没有账号");
    }else{
        NSLog(@"已经有账号了");
    }
    
    NSString *writeStr = [NSString stringWithFormat:@"账号:%@---密码:%@---姓:%@-名:%@---出生日期:%@---问题1:%@---答案1：%@---问题2:%@---答案2：%@---问题3:%@---答案3：%@",self.mailAddressStr,self.passwordStr,self.lastNameStr,self.firstNameStr,self.birthdayStr,self.question1Str,self.answer1Str,self.question2Str,self.answer2Str,self.question3Str,self.answer3Str];
    
    readAppleIDStr=[readAppleIDStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",writeStr] ]; //正确
    
    [readAppleIDStr writeToFile:filenamePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //注册成功以后，清除cookies
    NSURL *apmail_server_url = [NSURL URLWithString:@"https://appleid.apple.com"];
    if (apmail_server_url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:apmail_server_url];
        NSLog(@"苹果cookies是：%@",cookies);
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
}

#pragma mark -
#pragma mark  从我们自己的服务器请求苹果发送的验证码
- (void)receiveDDMailCode{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        //创建加载进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set some text to show the initial status.
        hud.label.text = NSLocalizedString(@"请求邮箱验证码...", @"HUD preparing title");
        // Will look best, if we set a minimum size.
        hud.minSize = CGSizeMake(100.f, 50.f);
        
        //初始化appleid创建页面
        [CXCreateRequest cxrequestGetUrlAddress:QMGetMailCode_URL parameter:nil isQMUrl:YES requestSuccess:^(id responseObject, NSString *aStr) {
            //NSLog(@"获取到的结果是:%@",aStr);
            NSError *error;
            NSData  *data = [aStr dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary  *dictionaryFromJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingMutableLeaves
                                                                                         error:&error];
            NSLog(@"获取到的值是：%@",aStr);
            
            NSString *accountStr = [dictionaryFromJson objectForKey:@"user"];
            NSString *codeStr = [dictionaryFromJson objectForKey:@"code"];
            
            if ([accountStr isEqualToString:self.mailAddressStr]) {
                self.mailCodeStr = codeStr;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //显示验证码
                    self.mailCodeField.text = self.mailCodeStr;
                    //创建加载进度完成提示
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"获得了验证码", @"HUD completed title");
                    [hud hideAnimated:YES afterDelay:1.f];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    [MyTools ToastNotification:@"请重新请求验证码" andView:self.view andLoading:NO andIsBottom:YES];
                });
            }
            
        } requestFailure:^(id responseObject, NSError *error) {
            NSLog(@"错误信息是:%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"加载失败，请重新请求", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
            });
        }];
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
}

#pragma mark -
#pragma mark 将注册成功之后的账号发送给服务器
- (void)postSuccessAccount{
    
    //0表示网络断开，1表示网络正在连接。
    BOOL networkFlag = [CheckNetwork isExistenceNetwork];
    if (networkFlag){
        //创建加载进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set some text to show the initial status.
        hud.label.text = NSLocalizedString(@"请求邮箱验证码...", @"HUD preparing title");
        // Will look best, if we set a minimum size.
        hud.minSize = CGSizeMake(100.f, 50.f);
        
        NSString *urlStr = @"";
        
        //如果是我们自己的服务器，那么就只传id就可以了。否则账号和密码
        if([MyTools isContainString:self.mailAddressStr ContainStr:DDMail_DNS])
        {
            urlStr = [NSString stringWithFormat:@"%@?id=%@",QMRegisterSuccess_URL,self.appleAccountID];
        }else{
            urlStr = [NSString stringWithFormat:@"%@?id=0&name=%@&password=%@",QMRegisterSuccess_URL,self.mailAddressStr,self.passwordStr];
        }
        
        
        //初始化appleid创建页面
        [CXCreateRequest cxrequestGetUrlAddress:urlStr parameter:nil isQMUrl:YES requestSuccess:^(id responseObject, NSString *aStr) {
            //NSLog(@"获取到的结果是:%@",aStr);
            NSError *error;
            NSData  *data = [aStr dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary  *dictionaryFromJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingMutableLeaves
                                                                                         error:&error];
            
            NSLog(@"获取到的值是：%@",aStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.f];
                [MyTools ToastNotification:@"账号ID上传成功" andView:self.view andLoading:NO andIsBottom:YES];
            });
            
            
            
        } requestFailure:^(id responseObject, NSError *error) {
            NSLog(@"错误信息是:%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //创建加载进度完成提示
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                UIImage *image = [[UIImage imageNamed:@"Failmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"上传失败，请重新请求", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:1.f];
            });
        }];
    }else{
        [MyTools ToastNotification:@"请检查网络状态！" andView:self.view andLoading:NO andIsBottom:NO];
    }
}

#pragma mark -
#pragma mark 放弃第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self.view resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.question1Array count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor blueColor];
    
    if (self.questionIndex == 1) {
        Questions *question = [self.question1Array objectAtIndex:indexPath.row];
        cell.textLabel.text = question.questionStr;
        
    }else if (self.questionIndex == 2){
        Questions *question = [self.question2Array objectAtIndex:indexPath.row];
        cell.textLabel.text = question.questionStr;
    }else{
        Questions *question = [self.question3Array objectAtIndex:indexPath.row];
        cell.textLabel.text = question.questionStr;
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.questionIndex == 1) {
        Questions *question = [self.question1Array objectAtIndex:indexPath.row];
        [self.answer1Btn setTitle:question.questionStr forState:UIControlStateNormal];
        self.question1Str = question.questionStr;
        self.question_id1Str = question.idStr;
        
    }else if (self.questionIndex == 2){
        Questions *question = [self.question2Array objectAtIndex:indexPath.row];
        [self.answer2Btn setTitle:question.questionStr forState:UIControlStateNormal];
        self.question2Str = question.questionStr;
        self.question_id2Str = question.idStr;
    }else{
        Questions *question = [self.question3Array objectAtIndex:indexPath.row];
        [self.answer3Btn setTitle:question.questionStr forState:UIControlStateNormal];
        self.question3Str = question.questionStr;
        self.question_id3Str = question.idStr;
    }
    
     [self.answerTableView setHidden:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (Screen_W == 320) {
        if (textField.tag == CaptchaFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 110);
        }
        if (textField.tag == MailCodeFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 239);
        }
        
    }else if (Screen_W == 375){
        if (textField.tag == CaptchaFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 100);
        }
        if (textField.tag == MailCodeFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 210);
        }
       
    }else if (Screen_W == 414){
        if (textField.tag == CaptchaFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 100);
        }
        if (textField.tag == MailCodeFieldTag) {
            self.appleIdScroll.contentOffset = CGPointMake(0, 200);
        }
    }
    
    
    //NSLog(@"开始编辑");
}// became first responder
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"结束编辑");
    self.mailAddressStr = self.mailField.text;
    self.lastNameStr = self.lastnameField.text;
    self.firstnameField.text = self.firstNameStr;
    self.passwordStr = self.passwordField.text;
    self.birthdayStr = self.birthdayField.text;
    self.answer1Str = self.answer1Field.text;
    self.answer2Str = self.answer2Field.text;
    self.answer3Str = self.answer3Field.text;
    self.captchAnswer = self.captchaField.text;
    self.mailCodeStr = self.mailCodeField.text;
    
    if (textField.tag == CaptchaFieldTag) {
        self.appleIdScroll.contentOffset = CGPointMake(0, 0);
    }
    if (textField.tag == MailCodeFieldTag) {
        self.appleIdScroll.contentOffset = CGPointMake(0, 0);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    switch (textField.tag) {
        case MailTextFieldTag:
        {
            NSLog(@"账号信息");
            [self validationAppleId];
        }
            break;
        case LastNameFieldTag:
        {
            NSLog(@"姓氏");
        }
            break;
        case FirstNameFieldTag:
        {
            NSLog(@"名字");
        }
            break;
        case BirthdayFieldTag:
        {
            NSLog(@"生日");
        }
            break;
        case PasswordFieldTag:
        {
            NSLog(@"密码");
            [self validatePassword];
        }
            break;
        case Answer1FieldTag:
        {
            NSLog(@"答案1");
        }
            break;
        case Answer2FieldTag:
        {
            NSLog(@"答案2");
        }
            break;
        case Answer3FieldTag:
        {
            NSLog(@"答案3");
        }
            break;
        case CaptchaFieldTag:
        {
            NSLog(@"打码图片");
        }
            break;
        case MailCodeFieldTag:
        {
            NSLog(@"邮件验证码");
            [self verficationCode];
        }
            break;
        default:
            break;
    }
    //NSLog(@"点击完成，完成编辑");
    return YES;
}

@end
