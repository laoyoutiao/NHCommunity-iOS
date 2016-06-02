//
//  StaffIconModel.h
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffIconModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *targetController;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL login;

- (UIViewController *)controller;
@end
