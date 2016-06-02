//
//  LoveBiz.h
//  NHCommunity
//
//  Created by aa on 16/3/21.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface LoveBiz : BaseBiz
- (void)requestLoveMsg:(NSDictionary *)param
               success:(void (^)(NSDictionary *))success
                  fail:(void (^)(NSString *))fail;
@end
