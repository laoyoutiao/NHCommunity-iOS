//
//  BaseViewController.h
//  Bendilianxi
//
//  Created by Arsenal on 15/3/17.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)createLeftBtn;

- (void)hiddenLoading;

- (void)showLoading;

- (void)showSuccessWithStatus:(NSString*)string;

- (void)showLoadingWithType:(SVProgressHUDMaskType)type;

- (void)showErrorWithStatus:(NSString *)string;

- (void)createTitleWithStr:(NSString *)str;

- (UIBarButtonItem *)createRightBtn:(NSString *)title sel:(SEL)seletor;

- (void)createBackBtn;

- (void)createLeftUserCenterBtn;

- (void)showLeft:(id)sender;

- (void)preloadLeftCtr;
@end
