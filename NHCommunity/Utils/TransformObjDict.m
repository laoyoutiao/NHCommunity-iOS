//
//  TransformObjDict.m
//  hera
//
//  Created by zhoubo on 13-11-9.
//  Copyright (c) 2013年 sintn. All rights reserved.
//

#import "TransformObjDict.h"

@implementation TransformObjDict

+(NSDictionary *) dictWithObject :(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    free(props);
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return dic;
    }
    
    return [self dictWithObject:obj];
}

//字典转成对象
+(id) objectWithDict: (NSDictionary *) dict theClass: (Class) theClass
{
    id result = nil;
    if(!dict || [dict count] <= 0 || !theClass){
        return result;
    }
    
    //记录所有属性
    NSMutableArray *classPropertys = [NSMutableArray array];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([theClass class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        [classPropertys addObject:propName];
    }
    free(props);
    
    result = [[theClass alloc] init];
    if (result) {
        NSArray *_keys = [dict allKeys];
        for (NSString *_aKey in _keys) {
            //该属性值存在
            if([classPropertys containsObject:_aKey]){
                //add
                id value = [dict objectForKey:_aKey];
                if ([value isKindOfClass:[NSNull class]]) {
                    value = @"";
                }
                
                if (value == nil ) {
                    value = @"";
                }
                
                if ([value isKindOfClass:[NSString class]]) {
                    if ([value isEqualToString:@"<null>"]) {
                        value = @"";
                    }
                }
                //end add
                    
                [result setValue:value forKey:_aKey];
            }
        }
    }
    
    return result;
}//end 字典转成对象


/**
    对象数组转化成字典数组
 */
+(NSArray *)dictsWithObjects: (NSArray *)objs
{
    NSMutableArray *result = nil;
    
    if(!objs || [objs count] <= 0){
        return result;
    }
    
    result = [NSMutableArray array];
    for (int i = 0; i < [objs count]; i++) {
        id obj = [objs objectAtIndex:i];
        NSDictionary *dict = [self dictWithObject:obj];
        [result addObject:dict];
    }
    
    return result;
}

/**
    字典数组转成对象数组
 */
+(NSArray *) objectsWithDicts: (NSArray *)dicts theClass: (Class) theClass
{
    NSMutableArray *result = nil;
    
    if(!dicts || [dicts count] <= 0){
        return result;
    }
    
    result = [NSMutableArray array];
    for(int i = 0; i < [dicts count]; i++){
        NSDictionary *dict = [dicts objectAtIndex:i];
        id obj = [self objectWithDict:dict theClass:theClass];
        [result addObject:obj];
    }
    
    return result;
}

@end






