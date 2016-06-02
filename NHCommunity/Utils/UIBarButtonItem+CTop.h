//
//  UIBarButtonItem+CTop.h
//  MobileFieldAdviser
//
//  Created by heyongjia on 15/8/1.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CTop)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action edgInset:(UIEdgeInsets)inset;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                            target:(id)target
                            action:(SEL)action
                          edgInset:(UIEdgeInsets)inset;
@end
