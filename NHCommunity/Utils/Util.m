//
//  Util.m
//  MobileFieldAdviser
//
//  Created by Arsenal on 15/8/4.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import "Util.h"
#import "UIBarButtonItem+CTop.h"

@implementation Util

+ (UIColor *)getColor: (NSString *)hexColor
{
    hexColor = [hexColor lowercaseString];
    unsigned int red, green, blue;
    
    NSRange range;
   
    range.length = 2;
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (UIBarButtonItem *)createNavBackButton:(id)target selector:(SEL)selector{
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithIcon:@"navigation_back_btn" highIcon:@"navigation_back_btn_press" target:target action:selector edgInset:UIEdgeInsetsMake(0, -10, 0, 10)];
    return backItem;
}

+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha;
    CGFloat components[] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGColorRef colorref = CGColorCreate(colorSpace,components);
    
    CGColorSpaceRelease(colorSpace);
    
    return colorref;
}

+ (void)pushAnimationWithLayer:(CALayer *)layer
                      duration:(CGFloat)duration
                          type:(NSString *)type
                      subtType:(NSString *)subType{
    
    CATransition *transaction = [CATransition animation];
    transaction.duration = duration;
    transaction.type = type;
    transaction.subtype = subType;
    transaction.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [layer addAnimation:transaction forKey:@"tableAnima"];
}

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)fmt {
    static NSDateFormatter *fmtter;
    
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init] ;
    }
    
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"yyyy-MM-dd HH:mm";
    }
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [fmtter setTimeZone: tz];
    [fmtter setDateFormat:fmt];
    if (date == nil) {
        return @"";
    }
    return [fmtter stringFromDate:date];
}

+ (NSDate*)dateFromString:(NSString*)str withFormat:(NSString*)fmt {
    static NSDateFormatter *fmtter;
    
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init] ;
        
    }
    
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"yyyy-MM-dd HH:mm";
    }
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [fmtter setTimeZone: tz];
    [fmtter setDateFormat:fmt];
    
    return [fmtter dateFromString:str];
}


+ (NSString *)imageToBase64:(UIImage *)image{
    NSData *data = nil;
    NSString *mimeType = nil;
    
//    if ([self imageHasAlph:image]) {
//        data = UIImagePNGRepresentation(image);
//        mimeType = @"image/png";
//    }else{
        data = UIImageJPEGRepresentation(image, 0.1);
        mimeType = @"image/jpg";
//    }
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

+ (BOOL)imageHasAlph:(UIImage *)image{
    CGImageAlphaInfo alph = CGImageGetAlphaInfo(image.CGImage);
    return (alph == kCGImageAlphaFirst || alph == kCGImageAlphaLast|| alph == kCGImageAlphaPremultipliedFirst || alph == kCGImageAlphaPremultipliedLast);
}

+ (UIImage*)rotateImage:(UIImage *)image
{
    int kMaxResolution = 960; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


+ (BOOL)regularWithString:(NSString *)searchText
                  withRex:(NSString *)rex{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:rex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result) {
        NSRange resultRange = [result rangeAtIndex:0];
        if (resultRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isLoginToDoOpereation{
    if ([[GlobalUtil shareInstant] loginWithCus]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

+ (BOOL)stringIsNull:(id)str{
    if (str == nil) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str isKindOfClass:[NSString class]]) {
        NSString *validateStr = str;
        if (validateStr.length == 0 || [validateStr isEqualToString:@"<null>"] || [validateStr isEqualToString:@""]) {
            return YES;
        }else
            return NO;
    }else{
        return NO;
    }
}

@end
