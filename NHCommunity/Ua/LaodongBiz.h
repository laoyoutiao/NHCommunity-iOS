//
//  LaodongBiz.h
//  NHCommunity
//
//  Created by aa on 16/3/20.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "BaseBiz.h"

@interface LaodongBiz : BaseBiz
- (void)requesLDBH:(NSDictionary *)param
           success:(void (^)(NSDictionary *))success
              fail:(void (^)(NSString *))fail;
@end
