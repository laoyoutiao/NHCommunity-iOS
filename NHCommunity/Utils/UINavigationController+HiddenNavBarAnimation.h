//
//  UINavigationController+HiddenNavBarAnimation.h
//  
//
//  Created by Arsenal on 15/6/9.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HiddenNavBarAnimation)

- (void)pushViewControllerWithTransitionToController:(UIViewController *)toController;

- (void)popViewControllerWithTransition;
@end
