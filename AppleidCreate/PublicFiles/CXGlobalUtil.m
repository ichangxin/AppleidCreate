//
//  CXGlobalUtil.m
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/10.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import "CXGlobalUtil.h"

@implementation CXGlobalUtil

#pragma mark 判断是否有网络
+(BOOL)networkIsPing
{
    /*监测网络状态*/
    
    BOOL isServerAvailable= NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if (([reachability connectionRequired]) || (NotReachable == reachability.currentReachabilityStatus)) {
        isServerAvailable = NO;
        
    } else if((ReachableViaWiFi == reachability.currentReachabilityStatus) || (ReachableViaWWAN == reachability.currentReachabilityStatus)){
        isServerAvailable = YES;
    }
    
    //    NSString *hostName = @"www.baidu.com";
    //    Reachability *hostReach = [Reachability reachabilityWithHostName:hostName];
    //    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    //    if (netStatus == NotReachable)
    //    {
    //        return NO;
    //    }
    //    return YES;
    return isServerAvailable;
    //    return [AFNetworkReachabilityManager sharedManager].reachable;
}



#pragma mark 正则匹配手机号

+ (BOOL)validateMobileNumber:(NSString *)string
{
    static NSString *tempStr = @"^((\\+86)?|\\(\\+86\\))0?1[34578]\\d{9}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)validatePostCodeNumber:(NSString *)string
{
    static NSString *tempStr = @"^[1-9]\\d{5}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)validatePassword:(NSString *)string
{
    
    static NSString *tempStr = @"^[^\\s\u4e00-\u9fa5]{6,16}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (str == nil || [str length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

//是否是纯数字
+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"(/^[0-9]*$/)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
    
}

//身份证号码校验
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


//姓名验证
+ (BOOL)checkUserName:(NSString *)userName{
    //不能含有数字标点
    NSString *regex=@"^[A-Za-z /\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"不能含有数字或标点符号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
    // 不能字母+汉字
    NSString *regex1 = @"^(([A-Za-z]+)[\u4e00-\u9fa5]+)$";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    if ([predicate1 evaluateWithObject:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"字母后面不能加汉字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
}

@end
