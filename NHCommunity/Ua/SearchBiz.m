//
//  SearchBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/17.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "SearchBiz.h"

@implementation SearchBiz

- (void)searchData:(NSDictionary *)param
           success:(void(^)(NSDictionary *responseObj))success
              fail:(void(^)(NSString *errorMsg))fail{
    //channel_id
//    size
//    time
//    type
//    title
    
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_SEARCH]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self searchData:_curParamDict
                                                                            success:success
                                                                               fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
                                                       NSLog(@"final respoint = %@",responObject);
                                                       success(responObject);
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];

}
@end
