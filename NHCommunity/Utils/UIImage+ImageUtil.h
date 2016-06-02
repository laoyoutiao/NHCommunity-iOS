//
//  UIImage+ImageUtil.h
//  Bendilianxi
//
//  Created by Arsenal on 15/5/16.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtil)

- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset;
@end
