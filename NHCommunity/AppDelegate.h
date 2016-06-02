//
//  AppDelegate.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseNavViewController;
@class UserCenterViewController;
@class MainTabBarViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;

- (void)initailLoginController;

- (void)initialMainController;

//- (BaseNavViewController *)mainViewController;

- (MainTabBarViewController *)mainViewController;

- (UserCenterViewController *)userCenterController;

- (void)logout;

- (void)requestUserInfo;

+ (instancetype)appDelegate;
@end

