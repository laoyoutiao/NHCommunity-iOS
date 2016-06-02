//
//  ActiveBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/30.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface ActiveBiz : BaseBiz

- (void)requestActive:(NSDictionary *)param
              success:(void(^)(NSDictionary *responseObj))success
                 fail:(void(^)(NSString *errorMsg))fail;
@end
