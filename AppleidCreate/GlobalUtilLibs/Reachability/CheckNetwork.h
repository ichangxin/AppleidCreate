//
//  CheckNetwork.h
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckNetwork : NSObject

+(BOOL)isExistenceNetwork;

//检测当前网络连接的状况，如果网络不畅通，那么就返回没有网络
+ (int) checkCurrentNetwork;

@end
