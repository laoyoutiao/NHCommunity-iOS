//
//  HttpManager.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (instancetype)shareInstant;

- (void)httpPostRequestWithUrl:(NSString *)url
                         param:(NSDictionary *)param
                       success:(void(^)(id responObject))successBlk
                          fail:(void(^)(NSError *error))failBlk;

- (void)httpPostWithNoAuthRequestWithUrl:(NSString *)url
                                   param:(NSDictionary *)param
                                 success:(void(^)(id responObject))successBlk
                                    fail:(void(^)(NSError *error))failBlk;

- (void)doLoginWithCallBack:(void(^)(BOOL flag,NSString *errorMsg))callBack;

- (AFHTTPRequestOperationManager *)httpManager;

- (NSString *)session;



@end
