//
//  UINavigationController+HiddenNavBarAnimation.m
//
//
//  Created by Arsenal on 15/6/9.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "UINavigationController+HiddenNavBarAnimation.h"

static CALayer *CurrentViewLayer = nil;
static CALayer *NextViewLayer = nil;

@interface NavAnimationDelegate : NSObject

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
+ (instancetype)shareInstant;
@end

@implementation NavAnimationDelegate

+ (instancetype)shareInstant{
    static dispatch_once_t onceToken;
    __strong static NavAnimationDelegate *delegate = nil;
    dispatch_once(&onceToken, ^{
        delegate = [[NavAnimationDelegate alloc] init];
    });
    
    return delegate;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (CurrentViewLayer.superlayer) {
        [CurrentViewLayer removeFromSuperlayer];
        CurrentViewLayer = nil;
    }
    
    if (NextViewLayer.superlayer) {
        [NextViewLayer removeFromSuperlayer];
        CurrentViewLayer = nil;
    }
}


@end

@implementation UINavigationController (HiddenNavBarAnimation)

- (void)pushViewControllerWithTransitionToController:(UIViewController *)toController{

    CurrentViewLayer = [self createCurViewSnapLayerWithTransForm:CATransform3DIdentity];
    
    [self pushViewController:toController animated:NO];
    
    NextViewLayer = [self createCurViewSnapLayerWithTransForm:CATransform3DIdentity];
    
    NextViewLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:CurrentViewLayer];
    [self.view.layer addSublayer:NextViewLayer];
    
    [CATransaction flush];
    
    [CurrentViewLayer addAnimation:[self animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [NextViewLayer addAnimation:[self animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
}

- (void)popViewControllerWithTransition{
    CurrentViewLayer = [self createCurViewSnapLayerWithTransForm:CATransform3DIdentity];
    
    [self popViewControllerAnimated:NO];
    
    NextViewLayer = [self createCurViewSnapLayerWithTransForm:CATransform3DIdentity];
    
    [NextViewLayer setFrame:CGRectMake(-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    [self.view.layer addSublayer:CurrentViewLayer];
    [self.view.layer addSublayer:NextViewLayer];
    
    [CATransaction flush];
    
    [CurrentViewLayer addAnimation:[self animationWithTranslation:self.view.bounds.size.width] forKey:nil];
    [NextViewLayer addAnimation:[self animationWithTranslation:self.view.bounds.size.width] forKey:nil];
}

#pragma mark -- private method

- (CABasicAnimation *)animationWithTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, translation, 0.f, 0.f)];
    animation.duration = 0.3f;
    animation.delegate = [NavAnimationDelegate shareInstant];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CALayer *)createCurViewSnapLayerWithTransForm:(CATransform3D)transform3D{
 
    if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
//    else {
//        UIGraphicsBeginImageContext(self.view.bounds.size);
//    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *snapshotLayer = [CALayer layer];
    snapshotLayer.transform = transform3D;
    snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
    snapshotLayer.frame = self.view.bounds;
    snapshotLayer.contents = (id)snapshot.CGImage;
    
    return snapshotLayer;
}
@end
