//
//  MainPageBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/22.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface MainPageBiz : BaseBiz

- (void)requestNews:(NSDictionary *)param
            success:(void(^)(NSDictionary *responseObj))success
               fail:(void(^)(NSString *errorMsg))fail;

@end
