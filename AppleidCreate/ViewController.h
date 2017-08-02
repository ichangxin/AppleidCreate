//
//  ViewController.h
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/8.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MailTextFieldTag = 10,
    LastNameFieldTag,
    FirstNameFieldTag,
    BirthdayFieldTag,
    PasswordFieldTag,
    Answer1FieldTag,
    Answer2FieldTag,
    Answer3FieldTag,
    CaptchaFieldTag,
    MailCodeFieldTag,   //邮件验证码
} MyTextFieldTag;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mailField;              //邮箱地址
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;          //姓
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;         //名
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;          //出生日期
@property (weak, nonatomic) IBOutlet UITextField *passwordField;          //密码
@property (weak, nonatomic) IBOutlet UITextField *answer1Field;           //问题一答案
@property (weak, nonatomic) IBOutlet UITextField *answer2Field;           //问题二答案
@property (weak, nonatomic) IBOutlet UITextField *answer3Field;           //问题三答案
@property (strong, nonatomic) IBOutlet UIImageView *captchaImageView;       //打码图片
@property (weak, nonatomic) IBOutlet UITextField *captchaField;           //打码验证码
@property (weak, nonatomic) IBOutlet UITextField *mailCodeField; //邮件验证码

@property (weak, nonatomic) IBOutlet UIButton *answer1Btn;
@property (weak, nonatomic) IBOutlet UIButton *answer2Btn;
@property (weak, nonatomic) IBOutlet UIButton *answer3Btn;
@property (weak, nonatomic) IBOutlet UIButton *pdShowBtn1;

@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UIButton *createAccountBtn;        //初始化请求 创建账号页面
@property (weak, nonatomic) IBOutlet UIButton *checkAccountBtn;         //检验账号信息按钮
@property (weak, nonatomic) IBOutlet UIButton *receiveAccountBtn;       //获取账号信息按钮
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;             //发送邮箱验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *submitAccountBtn;        //提交账号信息按钮
@property (weak, nonatomic) IBOutlet UIButton *receiveCodeBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *appleIdScroll;

@property (weak, nonatomic) IBOutlet UIButton *clearCookiesBtn;

- (IBAction)answer1BtnClicked:(id)sender;
- (IBAction)answer2BtnClicked:(id)sender;
- (IBAction)answer3BtnClicked:(id)sender;
- (IBAction)createCountClicked:(id)sender;
- (IBAction)receiveAccountInfo:(id)sender;
- (IBAction)validateAccountInfoClicked:(id)sender;
- (IBAction)pdShowBtnClicked1:(id)sender;
- (IBAction)sendMailCodeClicked:(id)sender;
- (IBAction)submitRegisterAccountClicked:(id)sender;
- (IBAction)receiveCodeDDClicked:(id)sender;
- (IBAction)clearCookiesClicked:(id)sender;




@end

