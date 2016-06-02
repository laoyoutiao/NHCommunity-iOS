//
//  SubmitBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/10.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface SubmitBiz : BaseBiz

- (void)submitData:(NSDictionary *)param
           success:(void(^)(NSDictionary *responseObj))success
              fail:(void(^)(NSString *errorMsg))fail;
@end
