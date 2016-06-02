//
//  CommunityBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/31.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface CommunityBiz : BaseBiz

- (void)requestCommunitMsg:(NSDictionary *)param
                   success:(void(^)(NSDictionary *responseObj))success
                      fail:(void(^)(NSString *errorMsg))fail;
@end
