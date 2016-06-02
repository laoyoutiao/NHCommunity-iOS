//
//  DatePickerView.h
//  MobileFieldAdviser
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateSelectedBlock)(NSString *date);

@interface DatePickerView : UIView

- (instancetype)initWithCallBack:(DateSelectedBlock)blk;

- (void)showPickerOnSuperView:(UIView *)superView ;

- (void)showPickerOnSuperView:(UIView *)superView curDate:(NSDate *)date;
@end
