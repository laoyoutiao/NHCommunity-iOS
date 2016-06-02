//
//  BaseTabBarViewController.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/17.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "Constant.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    if (IOS_7) {
        [self.tabBar setTranslucent:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
