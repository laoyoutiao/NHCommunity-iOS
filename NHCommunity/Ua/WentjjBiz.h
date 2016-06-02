//
//  WentjjBiz.h
//  NHCommunity
//
//  Created by aa on 16/3/20.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface WentjjBiz : BaseBiz

- (void)requestWtjj:(NSDictionary *)param
            success:(void (^)(NSDictionary *))success
               fail:(void (^)(NSString *))fail;
@end
