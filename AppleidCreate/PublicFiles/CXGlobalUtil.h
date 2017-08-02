//
//  CXGlobalUtil.h
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/10.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXGlobalUtil : NSObject

#pragma mark 判断是否有网络
+(BOOL)networkIsPing;

#pragma mark 正则匹配手机号
+ (BOOL)validateMobileNumber:(NSString *)string;

#pragma mark 正则匹配邮政编码
+ (BOOL)validatePostCodeNumber:(NSString *)string;

#pragma mark 正则匹配——禁止输入中文且是6-16位之间非空格的任意字符
+ (BOOL)validatePassword:(NSString *)string;

+ (BOOL)isEmpty:(NSString*)str;

//#pragma mark 判断耳机是否插入
//+ (BOOL)isHeadphone;

#pragma mark 是否是纯数字
+ (BOOL)isNumText:(NSString *)str;

//定制app的皮肤
//+ (void)customizeAppearance;

#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

//姓名校验
+(BOOL)checkUserName:(NSString *)userName;

@end
