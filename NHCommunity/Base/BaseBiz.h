//
//  BaseBiz.h
//  Bendilianxi
//
//  Created by Arsenal on 15/3/17.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBiz : NSObject{
    NSMutableDictionary *_curParamDict;
    NSMutableDictionary *_basePageParamDict;
    NSInteger _pageStartIndex;
}
+ (instancetype)bizInstant;

- (void)resetParamDictAndPageParam;

@end
