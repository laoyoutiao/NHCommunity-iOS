//
//  GlobalUtil.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/22.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "GlobalUtil.h"

@interface GlobalUtil(){
    NSMutableDictionary *_loginInfoDict;
    UserInfoVo *_userVo;
    
    BOOL _loginWithCus;
}
@end

@implementation GlobalUtil

static GlobalUtil *manger = nil;

+ (instancetype)shareInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc] init];
    });
    return manger;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _loginInfoDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)saveUserName:(NSString *)uname
                 pwd:(NSString *)pwd{
    [USERDEFUALT setObject:uname forKey:U_NAME];
    [USERDEFUALT setObject:pwd forKey:U_PWD];
    [USERDEFUALT synchronize];
    
}

- (NSDictionary *)loginInfo{

    if ([USERDEFUALT objectForKey:U_NAME] != nil) {
        [_loginInfoDict setObject:[USERDEFUALT objectForKey:U_NAME] forKey:U_NAME];
        [_loginInfoDict setObject:[USERDEFUALT objectForKey:U_PWD] forKey:U_PWD];
    }
    return _loginInfoDict;
}

- (BOOL)isLogin{
   return [[USERDEFUALT objectForKey:kLoginStatu] boolValue];
}

- (void)setLogin:(BOOL)flag{
    [USERDEFUALT setObject:@(flag) forKey:kLoginStatu];
    [USERDEFUALT synchronize];
}

- (void)setUserInfo:(UserInfoVo *)vo{
    _userVo = vo;
}

- (UserInfoVo *)userInfo{
    return _userVo;
}

- (BOOL)loginWithCus{
    return _loginWithCus;
}
- (void)setLoginWithCus:(BOOL)flag{
    _loginWithCus = flag;
}

@end
