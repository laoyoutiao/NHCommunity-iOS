//
//  Util.h
//  MobileFieldAdviser
//
//  Created by Arsenal on 15/8/4.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
@interface Util : NSObject

+ (BOOL)isLoginToDoOpereation;

+ (UIColor *)getColor: (NSString *)hexColor;

+ (UIBarButtonItem *)createNavBackButton:(id)target selector:(SEL)selector;

+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha;

/**
 *  左右切换
 *
 *  @param layer    layer
 *  @param duration 时间
 *  @param type     kCATransitionPush
 *  @param subType  kCATransitionFromLeft，kCATransitionFromRight
 */
+ (void)pushAnimationWithLayer:(CALayer *)layer
                      duration:(CGFloat)duration
                          type:(NSString *)type
                      subtType:(NSString *)subType;

+ (NSDate*)dateFromString:(NSString*)str withFormat:(NSString*)fmt ;

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)fmt;

+ (NSString *)imageToBase64:(UIImage *)image;

+ (UIImage*)rotateImage:(UIImage *)image;

+ (BOOL)imageHasAlph:(UIImage *)image;

+ (BOOL)regularWithString:(NSString *)searchText
                  withRex:(NSString *)rex;

+ (BOOL)stringIsNull:(id)str;
@end
