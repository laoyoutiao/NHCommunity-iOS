//
//  UserForSubmit.m
//  NHCommunity
//
//  Created by aa on 16/4/18.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "UserForSubmit.h"

@implementation UserForSubmit

- (void)setGender:(NSString *)gender{
    if ([gender isEqualToString:@"男"]) {
        _gender = @"1";
    }else{
        _gender = @"0";
    }
}

@end
