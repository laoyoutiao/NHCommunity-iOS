//
//  AppDelegate.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageViewCtr.h"
#import "BaseNavViewController.h"
#import "UserCenterViewController.h"
#import "UserBiz.h"
#import "UserInfoVo.h"
#import "LoginViewController.h"
#import "ExceptionHandler.h"
#import "AppVserionManager.h"
#import "UIAlertView+ShowWithBlk.h"
#import "MainTabBarViewController.h"

@interface AppDelegate ()
//@property (nonatomic,strong) BaseNavViewController *mainNav;
@property (nonatomic,strong) MainTabBarViewController *main;
@property (nonatomic, strong) UserCenterViewController *userCtr;

@end



@implementation AppDelegate

- (void)requestUserInfo{
    NSString *uname = [GlobalUtil shareInstant].loginInfo[U_NAME];
    [[UserBiz bizInstant] requestUserInfo:@{@"userName":uname}
                                  success:^(UserInfoVo *responseObj) {
                                      
                                  }
                                     fail:^(NSString *errorMsg) {
        
    }];
}

- (void)loginInBg{
    [[HttpManager shareInstant] doLoginWithCallBack:^(BOOL flag,NSString *errorMsg) {
        if (flag) {
            [[GlobalUtil shareInstant] setLogin:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginsInbg" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self requestUserInfo];
                });
            });
           
        }else{
            
        }
    }];
}

- (void)checkVersion{
    [AppVserionManager checkVersion:0 success:^(BOOL needUpgrate, NSInteger forceUpgrate, NSString *url) {
        if (needUpgrate) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"检测到新版本，是否需要升级" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
            [al showAlertViewOn:^(NSInteger index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }];
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //白色子
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //注册错误拦截器
    [ExceptionHandler setDefualtExceptionHandler];
    
    [self checkVersion];

    NSNumber *num = [USERDEFUALT objectForKey:kLoginStatu];
    if (num == nil || ![[GlobalUtil shareInstant] isLogin]) {
        [self initailLoginController];
    }else{

        [self initialMainController];
        
        //获取用户信息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self requestUserInfo];
            [self loginInBg];
        });
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)initialMainController{
//    MainPageViewCtr *main = [[MainPageViewCtr alloc] initWithNibName:@"MainPageViewCtr" bundle:nil];
    self.main = [[MainTabBarViewController alloc] init];
//    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:main];
    
//    self.mainNav = nav;
    
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:_main];
    
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
//    [self.revealSideViewController setPanInteractionsWhenClosed: PPRevealSideInteractionNavigationBar];
    
    self.revealSideViewController.fakeiOS7StatusBarColor = RGB(42.f, 111.f, 231.f, 1.0f);
    
    self.window.rootViewController = self.revealSideViewController;
}

- (void)initailLoginController{
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = login;
}

- (void)logout{
    [[GlobalUtil shareInstant] setLoginWithCus:NO];
    [[GlobalUtil shareInstant] setLogin:NO];
    [[GlobalUtil shareInstant] setUserInfo:nil];
//    self.mainNav = nil;
    self.main = nil;
    self.userCtr = nil;
    
    [[[HttpManager shareInstant] httpManager].operationQueue cancelAllOperations];
    
    [self initailLoginController];

}

- (MainTabBarViewController *)mainViewController{
    return self.main;
}

- (UserCenterViewController *)userCenterController{
    if (_userCtr == nil) {
        self.userCtr = [[UserCenterViewController alloc] initWithNibName:@"UserCenterViewController" bundle:nil];
    }
    return _userCtr;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (instancetype)appDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
