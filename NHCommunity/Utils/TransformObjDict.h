//
//  TransformObjDict.h
//  hera
//
//  Created by zhoubo on 13-11-9.
//  Copyright (c) 2013年 sintn. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface TransformObjDict : NSObject

/**
    通过对象返回一个NSDictionary，键是属性名称，值是属性值
 */
+(NSDictionary *) dictWithObject :(id)obj;

/**
    字典转成对象
 */
+(id) objectWithDict: (NSDictionary *) dict theClass: (Class) theClass;

/**
    对象数组转化成字典数组
 */
+(NSArray *)dictsWithObjects: (NSArray *)objs;

/**
    字典数组转成对象数组
 */
+(NSArray *) objectsWithDicts: (NSArray *)dicts theClass: (Class) theClass;



@end
