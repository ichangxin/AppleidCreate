//
//  CXCreateRequest.h
//  AppleidCreate
//
//  Created by ixingmi on 2017/2/10.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CXRequestPostSuccessBlock)( id responseObject, NSDictionary *dict);
typedef void (^CXRequestPostFailureBlock)( id responseObject, NSError *error);

typedef void (^CXRequestGetSuccessBlock)( id responseObject, NSString *aStr);
typedef void (^CXRequestGetFailureBlock)( id responseObject, NSError *error);

@interface CXCreateRequest : NSObject

//有的接口中，只跟了一个参数，没有对应的key，需要对此进行设置
+ (void)cxrequestPostUrlAddress:(NSString *)urlAddress
                     httpMethod:(NSString *)ahttpMethod
                  jsonParameter:(NSDictionary*)jsonParameter
                      parameter:(NSString *)aParameter
                           scnt:(NSString *)aScnt
                         apiKey:(NSString *)apiKey
                      sessionId:(NSString *)asessionId
                 requestSuccess:(CXRequestPostSuccessBlock)responseSuccess
                 requestFailure:(CXRequestPostFailureBlock)responseFailure;

//isQMUrl是否是来自自身服务器的请求 YES：表示来自我们自己的服务器请求，NO：表示来自苹果服务器的请求
+ (void)cxrequestGetUrlAddress:(NSString *)urlAddress parameter:(NSDictionary*)parameter isQMUrl:(BOOL)isQMUrl requestSuccess:(CXRequestGetSuccessBlock)responseSuccess requestFailure:(CXRequestGetFailureBlock)responseFailure;

//http返回的状态码含义
//   201(已创建)请求成功并且服务器创建了新的资源。
//　　202(已接受)服务器已接受请求，但尚未处理。
//　　203(非授权信息)服务器已成功处理了请求，但返回的信息可能来自另一来源。
//　　204(无内容)服务器成功处理了请求，但没有返回任何内容。
//   400(错误请求)服务器不理解请求的语法。
@end
