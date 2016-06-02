//
//  AppVserionManager.h
//  MobileFieldManager
//
//  Created by Arsenal on 15/11/6.
//  Copyright © 2015年 comtop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppVserionManager : NSObject

+ (void)checkVersion:(NSInteger)appType
             success:(void(^)(BOOL needUpgrate,NSInteger forceUpgrate ,NSString *url))success;

@end
