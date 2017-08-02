//
//  CXCreateRequest.m
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/10.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import "CXCreateRequest.h"

@implementation CXCreateRequest
+ (void)cxrequestPostUrlAddress:(NSString *)urlAddress
                     httpMethod:(NSString *)ahttpMethod
                  jsonParameter:(NSDictionary*)jsonParameter
                      parameter:(NSString *)aParameter
                           scnt:(NSString *)aScnt
                         apiKey:(NSString *)apiKey
                      sessionId:(NSString *)asessionId
                 requestSuccess:(CXRequestPostSuccessBlock)responseSuccess
                 requestFailure:(CXRequestPostFailureBlock)responseFailure{
    NSURL* url = [NSURL URLWithString:urlAddress];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 25;
    // 请求方式
    request.HTTPMethod = ahttpMethod;
    
    if (aParameter.length != 0) {
        //需要添加双引号，才可以请求成功。 例如："abcf@71tj.com"
        NSString *postData = [NSString stringWithFormat:@"\"%@\"",aParameter];
        // OC对象转JSON
        NSData* json = [postData dataUsingEncoding:NSUTF8StringEncoding];
        // 设置请求头
        request.HTTPBody = json;
    }else{
        // OC对象转JSON
        NSData* json = [NSJSONSerialization dataWithJSONObject:jsonParameter options:NSJSONWritingPrettyPrinted error:nil];
        // 设置请求头
        request.HTTPBody = json;
    }
    
    
    // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
    [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    //[request setValue:@"2083" forHTTPHeaderField:@"X-Apple-App-Id"];    //该值未发生变化  可以不带
    [request setValue:aScnt forHTTPHeaderField:@"scnt"];
    [request setValue:asessionId forHTTPHeaderField:@"X-Apple-ID-Session-Id"];   //该值会发生变化，和该值有关
    [request setValue:apiKey forHTTPHeaderField:@"X-Apple-Api-Key"];  //该值未发生变化  该值必须要带
    
    [request setValue:@"https://appleid.apple.com/account" forHTTPHeaderField:@"Referer"];  //该值未发生变化
    
    
    NSArray *userAgentArray = [NSArray arrayWithObjects:
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 BIDUBrowser/6.x Safari/537.31",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.44 Safari/537.36 OPR/24.0.1558.25 (Edition Next)",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36 OPR/23.0.1522.60 (Edition Campaign 54)",
                               @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
                               nil];
    NSString *userAgent = [userAgentArray objectAtIndex:arc4random()%5];
    
    //[request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];  //可以不带
    [request setValue:@"https://appleid.apple.com" forHTTPHeaderField:@"Origin"];  //不是必须的
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];    //不是必须的
    
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 错误判断
        if (data==nil||error)return;
        
        //如果请求接口是密码验证，密码如果合法，则不会返回数据。因此需要对此进行回调，保存新的scnt值
        if ([urlAddress isEqualToString:ApplePassword_URL] ||[urlAddress isEqualToString:AppleValidate_URL] ||[urlAddress isEqualToString:AppleVerification_URL]) {
            NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse*)response;
            
            if ([urlAddress isEqualToString:AppleVerification_URL]) {
                if ([ahttpMethod isEqualToString:@"PUT"]) {
                    //状态码是204，表示验证成功，但是不返回数据。
                    if (httpRespone.statusCode == 204) {
                        responseSuccess(response,nil);
                    }else if(httpRespone.statusCode == 400){ //状态码是400，表示数据有问题。
                        // 解析JSON
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        responseSuccess(response,dic);
                    }else{
                        responseFailure(response,error);
                    }
                }else{
                    // 解析JSON
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    if (dic != nil) {
                        responseSuccess(response,dic);
                    }else{
                        responseFailure(response,error);
                    }
                }
            }else{
                //状态码是204，表示验证成功，但是不返回数据。
                if (httpRespone.statusCode == 204) {
                    responseSuccess(response,nil);
                }else if(httpRespone.statusCode == 400){ //状态码是400，表示数据有问题。
                    // 解析JSON
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    responseSuccess(response,dic);
                }else{
                    responseFailure(response,error);
                }
            }
            
        }else{
            // 解析JSON
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dic != nil) {
                responseSuccess(response,dic);
            }else{
                responseFailure(response,error);
            }
        }
        
    }];
    
    [task resume];
}


+ (void)cxrequestGetUrlAddress:(NSString *)urlAddress parameter:(NSDictionary*)parameter isQMUrl:(BOOL)isQMUrl requestSuccess:(CXRequestGetSuccessBlock)responseSuccess requestFailure:(CXRequestGetFailureBlock)responseFailure
{
    NSURL* url = [NSURL URLWithString:urlAddress];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 25;
    // 请求方式
    request.HTTPMethod = @"get";
    
    NSArray *userAgentArray = [NSArray arrayWithObjects:
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 BIDUBrowser/6.x Safari/537.31",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.44 Safari/537.36 OPR/24.0.1558.25 (Edition Next)",
                               @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36 OPR/23.0.1522.60 (Edition Campaign 54)",
                               @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
                               nil];
    NSString *userAgent = [userAgentArray objectAtIndex:arc4random()%5];
    
    //如果是苹果服务器的请求，需要设置请求头，如果是我们自己的服务器的请求，不需要设置请求头
    if (!isQMUrl) {
        // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
        [request setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
        [request setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
        [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];  //不是必须的
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];    //不是必须的
    }
    
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 错误判断
        if (data==nil||error)return;
        // 解析JSON
        //NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (result != nil) {
            responseSuccess(response,result);
        }else{
            responseFailure(response,error);
        }
    }];
    
    [task resume];
}

@end
