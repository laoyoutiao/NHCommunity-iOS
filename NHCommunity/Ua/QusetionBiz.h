//
//  QusetionBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/8.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface QusetionBiz : BaseBiz

- (void)requestQuestionList:(NSDictionary *)param
                    success:(void(^)(NSDictionary *responseObj))success
                       fail:(void(^)(NSString *errorMsg))fail;
@end
