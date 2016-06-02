//
//  SearchBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/17.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface SearchBiz : BaseBiz

- (void)searchData:(NSDictionary *)param
           success:(void(^)(NSDictionary *responseObj))success
              fail:(void(^)(NSString *errorMsg))fail;
@end
