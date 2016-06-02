//
//  BDL_PlaceholdTextView.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/19.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "PlaceholdTextView.h"

@interface PlaceholdTextView()
{
    
    UIColor *_plachotColor;
    UIColor *_textColor;
}



@end

@implementation PlaceholdTextView

- (void)dealloc{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    
    self.placsHost = nil;
    _plachotColor = nil;
    _textColor = nil;
}

- (instancetype)initWithFrame:(CGRect)frame withPlacsHo:(NSString *)plashod{
    self = [super initWithFrame:frame];
    if (self) {
        self.placsHost = plashod;
        [self initalComponent];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initalComponent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initalComponent];
    }
    return self;
}

- (void)initalComponent{
    if (_placsHost == nil) {
        _placsHost = @"请输入您所需咨询的事项";
    }
    _plachotColor = [self gentColorWithString:@"d0d0d0"];
    _textColor = [self gentColorWithString:@"888888"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdtings) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditings) name:UITextViewTextDidEndEditingNotification object:nil];
    
    [self endEditings];
}

- (NSString *)text{
    if ([super.text isEqualToString:_placsHost] && super.textColor == _plachotColor) {
        return @"";
    }
    
    return [super text];
    
}

- (void)setText:(NSString *)text{
    if (text == nil || text.length == 0) {
        super.textColor = _plachotColor;
        [super setText:_placsHost];
        return;
    }
    [super setText:text];
}

- (void)endEditings{
    if ((super.text.length == 0 || self.text.length == 0) && _plachotColor) {
        super.textColor = _plachotColor;
        [super setText:self.placsHost];
    }
}

- (void)beginEdtings{
    if ([super.text isEqualToString:self.placsHost] && super.textColor == _plachotColor) {
        [super setText:@""];
        super.textColor = _textColor;
    }
}

- (void)setPlacsHost:(NSString *)placsHost{
    if ([_placsHost isEqualToString:placsHost]) {
        _placsHost = nil;
    }
    _placsHost = [placsHost copy];
    [self endEditings];
}

#pragma mark -- private
- (UIColor *)gentColorWithString:(NSString *)hexColor{
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
@end
