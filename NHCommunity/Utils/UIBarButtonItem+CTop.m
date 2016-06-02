//
//  UIBarButtonItem+CTop.m
//  MobileFieldAdviser
//
//  Created by heyongjia on 15/8/1.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import "UIBarButtonItem+CTop.h"

@implementation UIBarButtonItem (CTop)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                         highIcon:(NSString *)highIcon
                           target:(id)target
                           action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentImage.size};
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                         highIcon:(NSString *)highIcon
                           target:(id)target
                           action:(SEL)action
                         edgInset:(UIEdgeInsets)inset{
    UIBarButtonItem *item = [self itemWithIcon:icon highIcon:highIcon target:target action:action];
    UIButton *button = (UIButton *)item.customView;
    button.imageEdgeInsets = inset;
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                            target:(id)target
                            action:(SEL)action
                          edgInset:(UIEdgeInsets)inset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointMake(0, 0), CGSizeMake(60, 44)};
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    button.titleEdgeInsets = inset;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [button setBackgroundColor:[UIColor redColor]];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
