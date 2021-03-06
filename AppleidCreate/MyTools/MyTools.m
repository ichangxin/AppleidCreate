//
//  MyTools.m
//  IFishingGold
//
//  Created by 趣米-ixingmi on 14-6-4.
//  Copyright (c) 2014年 changxin. All rights reserved.
//

#import "MyTools.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "GCDiscreetNotificationView.h"
#import <AdSupport/AdSupport.h>

@implementation MyTools

+ (void)PopMsg:(NSString*)Msg withTitle:(NSString*)title viewController:(UIViewController *)aViewController
{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//													message:Msg
//												   delegate:nil
//										  cancelButtonTitle:@"确定"
//										  otherButtonTitles:nil];
//	[alert show];
//	[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:2.0];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:Msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消了");
        
    }];
    
    
    [alertVC addAction:defaultAction];
    
    [aViewController presentViewController:alertVC animated:YES completion:nil];
    
    //[self performSelector:@selector(dismissAlert1:) withObject:alertVC afterDelay:2.0];
}


/**
 *	@brief	获取颜色
 *
 *	@param 	stringToConvert 	取色数值
 *
 *	@return	返回颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//判断手机号是不是有效
+ (BOOL)checkTel:(NSString *)str
{
    // NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch)
    {
        //[self PopMsg:@"请输入有效手机号" withTitle:@"提示"];
        return NO;
    }
    else
    {
        return YES;
    }
}

//判断邮箱是否有效
+(BOOL)isValidEmail:(NSString *)email
{
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    BOOL isMatch = [emailTest evaluateWithObject:email];
    if (isMatch)
    {
        return YES;
    }
    else
    {
        //[self PopMsg:@"请输入有效的邮箱账号" withTitle:@"提示"];
        return NO;
    }
}

//判断QQ号码是否有效
+(BOOL)isValidQQ:(NSString *)qqNum
{
    NSString *patternQQ = @"^[1-9][0-9]{4,10}$";
    NSPredicate *regexQQ = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",patternQQ];
    
    BOOL isMatchQQ = [regexQQ evaluateWithObject:qqNum];

    if (isMatchQQ)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断密码是否有效
+ (BOOL)isValidPassword:(NSString *)str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z0-9]{6,16}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
    {
        NSLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    NSLog(@"%@ isNumbericString: NO", str);
    return NO;
}

//校验用户名
+ (BOOL) validateUserName : (NSString *) str
{
    NSString *patternStr = [NSString stringWithFormat:@"^.{0,4}$|.{21,}|^[^A-Za-z0-9u4E00-u9FA5]|[^\\wu4E00-u9FA5.-]|([_.-])1"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

//校验用户生日
+ (BOOL) validateUserBornDate : (NSString *) str
{
    
    NSString *patternStr = @"^((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
    {
        NSLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    NSLog(@"%@ isNumbericString: NO", str);
    return NO;
}

//获取mac地址
+ (NSString *) macaddress

{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = nil;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        //  NSLog(@"Error: %@", errorFlag);
        if (msgBuffer) {
            free(msgBuffer);
        }
        
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

//获取广告标识符存储到keychain中去
+ (NSString *)getIDFA
{
    NSString *os_version = [[UIDevice currentDevice] systemVersion];    //系统版本
    double osVersion = [os_version doubleValue];
    NSString *idfa = nil;
    NSString *idfv = nil;
    NSString *imei = nil;
    if (osVersion >= 7.0)
    {
        //厂商唯一标识符identifierForVender  iOS6中推出的UDID替代方案，该方法对于同一厂商的应用返回相同的值，不同厂商所得到的值不同。
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    else
    {
        imei = [self macaddress];
    }
    //NSLog(@"获取到的imei是4：%@",imei);
    return imei;
}

//获取当前时间
+ (double)getCurrentTime
{
    //ios获取自1970年以来的毫秒数
    NSTimeInterval timestamp=[[NSDate date] timeIntervalSince1970]*1000;
    return timestamp;
}

//应用版本号对比
+ (int)getVersionNumber:(NSString *)version
{
    NSArray * arr = [version componentsSeparatedByString:@"."];
    if (arr.count >= 3) {
        NSString * a = [arr objectAtIndex:0];
        NSString * b = [arr objectAtIndex:1];
        NSString * c = [arr objectAtIndex:2];
        return a.intValue * 100 + b.intValue * 10 + c.intValue;
    }
    else
        return 0;
}

//当前应用的版本号
+ (NSString *)getAppCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //当前app版本
    NSString *current_version = [infoDictionary objectForKey:@"CFBundleVersion"];
    return current_version;
}

//获取推送的device_token
+ (NSString *)getDeviceToken:(NSString *)aToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:aToken forKey:@"device_token"];
    [userDefaults synchronize];
    return aToken;
}

//发送获取到的device_token
+ (NSString *)sendDeviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *device_token = [userDefaults objectForKey:@"device_token"];
    if (device_token == nil)
    {
        device_token = @"";
    }
    return device_token;
}

//color转Image
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

//画图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//提示视图
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:4.0];
}


//是否包含某个字符串
+ (BOOL)isContainString:(NSString *)aStr ContainStr:(NSString *)containStr{
    if([aStr rangeOfString:containStr].location != NSNotFound)
    {
        return YES;
    }else{
        return NO;
    }
}

@end
