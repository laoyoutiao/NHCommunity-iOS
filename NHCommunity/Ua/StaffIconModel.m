//
//  StaffIconModel.m
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "StaffIconModel.h"

@implementation StaffIconModel

- (UIViewController *)controller{
    UIViewController *viewController = [[NSClassFromString(_targetController) alloc] init];
    return viewController;
}
@end
