//
//  BaseBiz.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/17.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BaseBiz.h"


@implementation BaseBiz

+ (instancetype)bizInstant
{
    return [[[self class] alloc] init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _curParamDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        _basePageParamDict = [[NSMutableDictionary alloc] init];
        _pageStartIndex = 1;
        [_basePageParamDict setObject:@(_pageStartIndex) forKey:P_START];
        [_basePageParamDict setObject:@(_pageStartIndex * P_PAGESIZE) forKey:P_END];
    }
    return self;
}

- (void)resetParamDictAndPageParam{
    [_curParamDict removeAllObjects];
    _pageStartIndex = 1;
    [_basePageParamDict setObject:@(_pageStartIndex) forKey:P_START];
    [_basePageParamDict setObject:@(_pageStartIndex * P_PAGESIZE) forKey:P_END];
}
@end
