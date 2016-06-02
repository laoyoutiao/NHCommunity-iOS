//
//  DatePickerView.m
//  MobileFieldAdviser
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import "DatePickerView.h"
#import "AppDelegate.h"
@interface DatePickerView()
{
    UIDatePicker *_picker;
}
@property (nonatomic, copy) DateSelectedBlock dblk;

@end

@implementation DatePickerView

#define COLOR_BLACK_BG_ALPH [[UIColor blackColor] colorWithAlphaComponent:0.7]

- (instancetype)initWithCallBack:(DateSelectedBlock)blk{
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:COLOR_BLACK_BG_ALPH];
        self.dblk = blk;

    }
    return self;
}

- (void)showPickerOnSuperView:(UIView *)superView curDate:(NSDate *)date{
    if (!_picker) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - 216, self.frame.size.width, 44)];
        
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithTitle:@"  取消"
                                                                      style:UIBarButtonItemStylePlain target:self
                                                                     action:@selector(toobarCancleClick)];
        
        UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定  "
                                                                    style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(toobarConfirmClick)];
        
        UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolBar setItems:@[cancleBtn,flexBtn,sureBtn]];
        [self addSubview:toolBar];
    }
    
    [_picker removeFromSuperview];
    _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216, self.frame.size.width,  216)];
    [_picker setBackgroundColor:[UIColor whiteColor]];
    _picker.datePickerMode = UIDatePickerModeDate;
     NSDate *maxDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
    [_picker setMaximumDate:maxDate];
    
    [self addSubview:_picker];
    
    if (date != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_picker setDate:date animated:YES];
        });
    }
    
    UIWindow *keywindow = [[[UIApplication sharedApplication] delegate ] window];
    if([keywindow windowLevel] > 1990)//1990是window的的界别，高级别的用rootview处理
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.rootViewController.view addSubview:self];
        [app.window.rootViewController.view  bringSubviewToFront:self];
        [app.window.rootViewController.view endEditing:YES];
    }
    else{
        [keywindow addSubview: self];
        [keywindow bringSubviewToFront:self];
        [keywindow endEditing:YES];
    }
    
    
    
    [self doanimiation];
}

- (void)showPickerOnSuperView:(UIView *)superView{
    [self showPickerOnSuperView:superView curDate:nil];
}

- (void)toobarConfirmClick
{
    NSDate *date = [_picker date];
    NSString *dateString = [Util stringFromDate:date withFormat:DATE_FORMMAT_STYLE_NORMARL];
    if (_dblk) {
        _dblk(dateString);
    }
    [self toobarCancleClick];
    
}

- (void)toobarCancleClick{
    [self doanimiation];
   
}

- (void)doanimiation{
    __block BOOL remove = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        if (frame.origin.y == self.frame.size.height) {
            frame.origin.y = 0;
            
        }else{
            frame.origin.y = self.frame.size.height;
            remove = YES;
        }
        [self setFrame:frame];
    } completion:^(BOOL finished) {
        if (remove) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }];
}

@end
