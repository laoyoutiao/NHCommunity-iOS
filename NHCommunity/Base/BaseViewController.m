//
//  BaseViewController.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/17.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UserCenterViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc{
    [self hiddenLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (IOS_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        //适配ios7
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIBarButtonItem *)createRightBtn:(NSString *)title sel:(SEL)seletor{
//    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendBtn setTitle:title forState:UIControlStateNormal];
//    [sendBtn setFrame:CGRectMake(0, 0, 50, 44)];
//    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    [sendBtn addTarget:self action:seletor forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
////    self.navigationItem.rightBarButtonItem= rightItem;
//    return rightItem;
//}



//- (void)createLeftBtn{
////    self.navigationController.navigationItem.leftBarButtonItem
//    CGFloat height = 44;
//    if (IOS_7) {
//        height = 64;
//    }
//    UIImage *img = [UIImage imageNamed:@"back"];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    [imgView setFrame:CGRectMake(0, (height - 21) / 2, 19, 21)];
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, height)];
//    [leftView addSubview:imgView];
////    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftView.frame.size.width - 1, -10, 1, leftView.frame.size.height)];
////    [label setBackgroundColor:[UIColor lightGrayColor]];
////    [leftView addSubview:label];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
//    [leftView addGestureRecognizer:tap];
//    
//    self.navigationItem.leftBarButtonItem = item;
//}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)createTitleWithStr:(NSString *)str{
//    self.title = str;
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:18], UITextAttributeFont,nil]];
//}

#pragma mark -- hud
- (void)hiddenLoading{
    [SVProgressHUD dismiss];
}

- (void)showLoadingWithType:(SVProgressHUDMaskType)type{
     [SVProgressHUD showWithStatus:@"正在加载" maskType:type];
}
- (void)showLoading{
//    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [self showLoadingWithType:SVProgressHUDMaskTypeClear];
}

- (void)showSuccessWithStatus:(NSString*)string{
    [SVProgressHUD showSuccessWithStatus:string];
}

- (void)showErrorWithStatus:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)createBackBtn{
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
}

- (void)createLeftUserCenterBtn{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"m_user" highIcon:@"m_user" target:self action:@selector(showLeft:) edgInset:UIEdgeInsetsMake(0, -5, 0, 5)];
}

- (void)showLeft:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        UserCenterViewController *left = [[AppDelegate appDelegate] userCenterController];
        [left reloadData];
        [self.revealSideViewController pushViewController:left onDirection:PPRevealSideDirectionLeft animated:YES];
    });
    
}

- (void)preloadLeftCtr{
    UserCenterViewController *left = [[AppDelegate appDelegate] userCenterController];

    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
}
@end
