//
//  CheckNetwork.m
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork = YES;
    
    int networkState = [self checkCurrentNetwork];
    
    switch (networkState)
    {
        case 0:
        {
            //  isExistenceNetwork = NO;
            isExistenceNetwork = NO;
        }
            break;
        case 1:
        {
            //   isExistenceNetwork = YES;
            //connectStr = @"WWAN";
            isExistenceNetwork = YES;
        }
            break;
        case 2:
        {
            //   isExistenceNetwork = YES;
            //connectStr = @"wifi";
            isExistenceNetwork = YES;
        }
            break;
        default:
            break;
    }
	return isExistenceNetwork;
}


//检测当前网络连接的状况，如果网络不畅通，那么就返回没有网络
+ (int) checkCurrentNetwork
{
    int kind;
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        kind = 0;
        //  NSLog(@"没有网络");
    }
    else
    {
        //根据获得的连接标志进行判断
        BOOL isReachable = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        
        if((isReachable && !needsConnection)==YES)
        {
            ///能够连接网络
            if((flags& kSCNetworkReachabilityFlagsIsWWAN)==kSCNetworkReachabilityFlagsIsWWAN)
            {
                kind = 1;
                //      NSLog(@"当前网络是手机网络");
            }
            else
            {
                //    NSLog(@"当前网络是wifi");
                kind = 2;
            }
        }
        else
        {
            kind = 0;
            //  NSLog(@"不能连接网络");
        }
    }
    return kind;
}
@end
