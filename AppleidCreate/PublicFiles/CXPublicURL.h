//
//  CXPublicURL.h
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/10.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#ifndef CXPublicURL_h
#define CXPublicURL_h

#define DDMail_DNS    @"71tj.com"
#define Neteasy_DNS    @"163.com"

/**
 创建账号的请求接口  同时也是最后一步，验证账号信息的接口
 还有一种接口：https://appleid.apple.com/account#!&page=create
 //https://appleid.apple.com/account
 //https://appleid.apple.com/account/create?fragment=true
 */
#define AppleCount_URL              @"https://appleid.apple.com/account"
/**
 获取打码图片的请求接口
 */
#define AppleCaptcha_URL            @"https://appleid.apple.com/captcha"
/**
 验证邮箱地址和Apple账号的请求接口
 */
#define AppleAppleId_URL            @"https://appleid.apple.com/account/validation/appleid"
/**
 验证密码的请求接口  在提交validate接口的时候，会先发送一次password接口，同样是没有数据返回。
 */
#define ApplePassword_URL           @"https://appleid.apple.com/account/validate/password"
/**
 验证所有信息的请求接口   提交所有信息 同时提交打码图片的信息，如果验证成功，则无数据返回。
 */
#define AppleValidate_URL           @"https://appleid.apple.com/account/validate"
/**
 验证所有信息之后，发送到邮件的验证码接口   同时该接口也是验证邮箱验证码是否正确的接口。
 */
#define AppleVerification_URL       @"https://appleid.apple.com/account/verification"

//110.41.25.246测试用的，现在已经不能使用。
/**
 获取苹果发送到邮箱的验证码。   get请求
 */
#define QMGetMailCode_URL           @"http://110.41.25.246/getCode.php"
/**
 获取注册appleID的账号信息。   get请求
 */
#define QMGetAppleIdInfo_URL        @"http://110.41.25.246/getAccount.php"
/**
 将注册成功的账号id，回传给服务器进行保存。   get请求  回传参数：id
 */
#define QMRegisterSuccess_URL       @"http://110.41.25.246/postRegSuccess.php"


#define IMAGE_OF_NAME(STR1)  [UIImage imageNamed:STR1]
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width

#endif /* CXPublicURL_h */
