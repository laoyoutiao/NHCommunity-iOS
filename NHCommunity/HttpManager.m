//
//  HttpManager.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "HttpManager.h"
#import "BDL_JsonSeriler.h"

@interface HttpManager()<NSURLConnectionDataDelegate>{
    NSMutableData *_responseData;
    
    

}
@property (nonatomic, strong) NSDictionary *curRequestParam;
@property (nonatomic, copy) NSString *httpToken;
@property (nonatomic, strong) NSMutableDictionary *sessionDict;

@property (nonatomic, assign) NSInteger reqCount;
@property (nonatomic, copy) NSString *curSeletorName;
@end

@implementation HttpManager
static HttpManager *manger = nil;

+ (instancetype)shareInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc] init];
    });
    return manger;
}

#define  kUserDefaultsCookie @"coky"


- (instancetype)init{
    self = [super init];
    if (self) {
        self.sessionDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_sessionDict setObject:[StringUtil generateUUID] forKey:SESSION_KEY];
        _responseData = [[NSMutableData alloc] initWithLength:0];
    }
    return self;
}

- (NSString *)session{
    return [NSString stringWithFormat:@"%@",_sessionDict[SESSION_KEY]];
}


- (void)httpPostWithNoAuthRequestWithUrl:(NSString *)url
                                   param:(NSDictionary *)param
                                 success:(void(^)(id responObject))successBlk
                                    fail:(void(^)(NSError *error))failBlk{
    
    [[self httpManager].requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    
    [[self httpManager] POST:url
                  parameters:param
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         
                         
                         if ([responseObject[@"code"] integerValue] == 1) {
                             
//                             NSLog(@"请求失败, = %@",responseObject);
                             
                            failBlk(responseObject[DATA_KEY_MSG]);
                             
                         }else{
//                             NSLog(@"请求成功 -- respone obj = %@",responseObject);
                             successBlk(responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         failBlk(error);
                     }];

}

- (void)httpPostRequestWithUrl:(NSString *)url
                         param:(NSDictionary *)param
                       success:(void(^)(id responObject))successBlk
                          fail:(void(^)(NSError *error))failBlk{
    
    self.curSeletorName = url;
    
    NSMutableDictionary *finalParam = [NSMutableDictionary dictionaryWithDictionary:param];
    __weak __typeof(self)weakSelf = self;
    //添加服务器返回的 token
    if (![[GlobalUtil shareInstant] loginWithCus]) {
        if ([[GlobalUtil shareInstant] isLogin]) {
            if (_httpToken != nil) {
                [finalParam setObject:_httpToken forKey:@"token"];
//                NSLog(@"final param = %@",finalParam);
            }
        }
    }
    
    [[self httpManager].requestSerializer setValue:[NSString stringWithFormat:@"%@",_sessionDict[SESSION_KEY]] forHTTPHeaderField:@"Cookie"];
    
    [[self httpManager] POST:url
                  parameters:finalParam
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         
                         weakSelf.reqCount ++;
//                         NSLog(@"op1 = %@",operation.request.allHTTPHeaderFields);
//                         NSLog(@"op2 = %@",operation.response.allHeaderFields);
                         
                         if (weakSelf.reqCount == 3) {
                             weakSelf.reqCount = 0;
                             failBlk([NSError errorWithDomain:url code:0 userInfo:@{@"msg":@"请求失败"}]);
                             return ;
                         }
                         
                         if ([responseObject[@"code"] integerValue] == 1) {
                             NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"token"]];
                             if (token.length == 0) {
                                 [weakSelf doLoginWithCallBack:^(BOOL flag,NSString *errorMsg) {
                                     successBlk(@{RE_REQUEST_FLAG:@(flag)});
                                 }];
                             }else{
//                                 NSLog(@"请求成功,含有token请求完成 -- respone obj = %@",responseObject);
                                 weakSelf.reqCount = 0;
                                 successBlk(responseObject);
                             }
                         }else{
//                             NSLog(@"请求成功 -- respone obj = %@",responseObject);
                             weakSelf.reqCount = 0;
                             successBlk(responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         weakSelf.reqCount = 0;
                         failBlk(error);
                     }];
}

- (AFHTTPRequestOperationManager *)httpManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //加入超时设置 30s
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

#pragma mark -- 认证方法
- (void)doLoginWithCallBack:(void(^)(BOOL flag,NSString *errorMsg))callBack{
    
    
    NSLog(@"认证开始 --------------------------");
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *uname = [GlobalUtil shareInstant].loginInfo[U_NAME];
    NSString *upwd = [GlobalUtil shareInstant].loginInfo[U_PWD];
    [dict setObject:uname forKey:@"username"];
    [dict setObject:upwd forKey:@"password"];
//    if (self.httpToken != nil) {
//        [dict setObject:_httpToken forKey:@"token"];
//    }
//  
//    [[self httpManager].requestSerializer setValue:[NSString stringWithFormat:@"%@",_sessionDict[SESSION_KEY]] forHTTPHeaderField:@"Cookie"];
    
    NSLog(@"login parma = %@",dict);
    [[self httpManager] POST:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_LOGIN]
                  parameters:dict
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"login success = %@",responseObject);
                         NSDictionary *headerDict = [operation.response allHeaderFields];
                         NSString *jession = [self anlyCookieWithCookieString:headerDict[@"Set-Cookie"]];
                         if (jession != nil) {
                             [_sessionDict setObject:jession forKey:SESSION_KEY];
                         }
                         
                         if ([responseObject[@"code"] integerValue] == 0) {
                             NSString *token = responseObject[@"token"];
                             if (token == nil || token.length == 0) {
                                 NSLog(@"-------------------------- 认证失败 ----------------------------------");
                             }else{
                                 self.httpToken = token;
                                  NSLog(@"-------------------------- 认证成功 ----------------------------------");
                                 
                                 NSDictionary *data = responseObject[@"data"];
                                 if ([data isKindOfClass:[NSDictionary class]]) {
                                     NSString *userId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userid"]];
                                     if (userId.length > 0) {
                                         UserInfoVo *vo = [[GlobalUtil shareInstant] userInfo];
                                         if (vo == nil) {
                                             UserInfoVo *vo = [[UserInfoVo alloc] init];
                                             [vo setUSER_ID:userId];
                                             [[GlobalUtil shareInstant] setUserInfo:vo];
                                         }else{
                                             [vo setUSER_ID:userId];
                                             [[GlobalUtil shareInstant] setUserInfo:vo];
                                         }
                                     }
                                 }
                             }
                         }
                         
                        
                         //认证后，返回。
                         callBack(_httpToken.length == 0 ? NO : YES,responseObject[DATA_KEY_MSG]);

                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"login error = %@",error);
                         callBack(NO,@"登录失败，请稍后再试");
    }];
    
//    [[self httpManager].operationQueue addOperation:[[self httpManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: operation.request.URL];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
//        
//        NSDictionary *headerDict = [operation.response allHeaderFields];
//        NSString *jession = [self anlyCookieWithCookieString:headerDict[@"Set-Cookie"]];
//        if (jession != nil) {
//            [_sessionDict setObject:jession forKey:SESSION_KEY];
//        }
//        
//        if ([responseObject[@"code"] integerValue] == 0) {
//            NSString *token = responseObject[@"token"];
//            self.httpToken = token;
//        }
//        
//        NSLog(@"-------------------------- 认证成功 ----------------------------------");
//        //认证后，返回。
//        callBack(_httpToken.length == 0 ? NO : YES);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"fail = %@",error);
//        callBack(NO);
//    }]];
}


//- (void)httpPostRequestWithUrl:(NSString *)url
//                         param:(NSDictionary *)param
//                       success:(void(^)(id responObject))successBlk
//                          fail:(void(^)(NSError *error))failBlk{
//    
//    self.curSeletorName = url;
//    
//    NSMutableDictionary *finalParam = [NSMutableDictionary dictionaryWithDictionary:param];
//    __weak __typeof(self)weakSelf = self;
//    //添加服务器返回的 token
//    if (_httpToken != nil) {
//        [finalParam setObject:_httpToken forKey:@"token"];
//        NSLog(@"final param = %@",finalParam);
//    }
//    
//    NSData *postBody = [BDL_JsonSeriler jsonDataFromDict:finalParam];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [urlRequest setHTTPBody:postBody];
//    [urlRequest setHTTPMethod:@"POST"];
//    
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            NSLog(@"cookiet = %@",cookie);
//        }
//    }
//    
//    
////    [[self httpManager].requestSerializer setValue:[NSString stringWithFormat:@"%@",_sessionDict[SESSION_KEY]] forHTTPHeaderField:@"Cookie"];
//    
//    [[self httpManager] POST:url
//                  parameters:finalParam
//                     success:^(AFHTTPRequestOperation *operation, id responseObject){
//                         
//                        weakSelf.reqCount ++;
//                        NSLog(@"op1 = %@",operation.request.allHTTPHeaderFields);
//                        NSLog(@"op2 = %@",operation.response.allHeaderFields);
//                         
//                         if (weakSelf.reqCount == 3) {
//                             weakSelf.reqCount = 0;
//                             failBlk([NSError errorWithDomain:url code:0 userInfo:@{@"msg":@"请求失败"}]);
//                             return ;
//                         }
//                         
//                          if ([responseObject[@"code"] integerValue] == 1) {
//                              [weakSelf doLoginWithCallBack:^(BOOL flag) {
//                                  
//                                  successBlk(@{RE_REQUEST_FLAG:@(flag)});
//                              }];
//                          }else{
//                              NSLog(@"请求成功 -- respone obj = %@",responseObject);
//                              weakSelf.reqCount = 0;
//                              successBlk(responseObject);
//                          }
//                     }
//                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        weakSelf.reqCount = 0;
//                        failBlk(error);
//                  }];
//}
//
//- (AFHTTPRequestOperationManager *)httpManager{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    return manager;
//}
//
//#pragma mark -- 认证方法
//- (void)doLoginWithCallBack:(void(^)(BOOL flag))callBack{
//    
//
//    NSLog(@"认证开始 --------------------------");
//    
//   __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_LOGIN relativeToURL:RETIVE_URL]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *uname = [GlobalUtil shareInstant].loginInfo[U_NAME];
//    NSString *upwd = [GlobalUtil shareInstant].loginInfo[U_PWD];
//    NSString *loginBody = [NSString stringWithFormat:@"username=%@&password=%@",uname,upwd];
//    if (self.httpToken != nil) {
//        loginBody = [NSString stringWithFormat:@"%@&token=%@",loginBody,_httpToken];
//    }
//    NSData *bodyData = [loginBody dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:bodyData];
//    
//    NSLog(@"认证 req post header = %@",request.allHTTPHeaderFields);
//    
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
////            NSLog(@"cookiet = %@",cookie);
//        }
//    }
//    
////    [[self httpManager].requestSerializer setValue:[NSString stringWithFormat:@"%@",_sessionDict[SESSION_KEY]] forHTTPHeaderField:@"Cookie"];
//    
//    [[self httpManager].operationQueue addOperation:[[self httpManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: operation.request.URL];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
//        
//        NSDictionary *headerDict = [operation.response allHeaderFields];
//        NSString *jession = [self anlyCookieWithCookieString:headerDict[@"Set-Cookie"]];
//        if (jession != nil) {
//            [_sessionDict setObject:jession forKey:SESSION_KEY];
//        }
//        
//        if ([responseObject[@"code"] integerValue] == 0) {
//            NSString *token = responseObject[@"token"];
//            self.httpToken = token;
//        }
//        
//        NSLog(@"-------------------------- 认证成功 ----------------------------------");
//        //认证后，返回。
//        callBack(_httpToken.length == 0 ? NO : YES);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"fail = %@",error);
//        callBack(NO);
//    }]];
//}

#pragma mark -- privte methods

- (NSString *)anlyCookieWithCookieString:(NSString *)cookieStr{
    NSArray *data = [cookieStr componentsSeparatedByString:@";"];
    NSString *jessionId = nil;
    if (data.count == 2) {
        NSString *jessionIdString = data[0];
        NSArray *jessionArray = [jessionIdString componentsSeparatedByString:@"="];
        if (jessionArray.count == 2) {
            jessionId = jessionArray[1];
        }
    }
    return jessionId;
}
@end
